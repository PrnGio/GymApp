// Questa schermata gestisce l'allenamento in corso

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelli/esercizio.dart';
import '../modelli/registro_allenamento.dart';
import '../stati/allenamento_provider.dart';

class SchermataSessioneAttiva extends StatefulWidget {
  final String registroId;

  const SchermataSessioneAttiva({super.key, required this.registroId});

  @override
  State<SchermataSessioneAttiva> createState() =>
      _SchermataSessioneAttivaState();
}

class _SchermataSessioneAttivaState extends State<SchermataSessioneAttiva> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _ottieniController(String chiave, String testoIniziale) {
    return _controllers.putIfAbsent(
      chiave,
      () => TextEditingController(text: testoIniziale),
    );
  }

  void _svuotaControllers() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
  }

  String _formattaPeso(double peso) {
    return peso % 1 == 0 ? peso.toInt().toString() : peso.toString();
  }

  void _mostraDialogAggiungiEsercizio(
    BuildContext context,
    RegistroAllenamento registro,
  ) {
    final provider = context.read<AllenamentoProvider>();
    final eserciziDisponibili = provider.esercizi;
    if (eserciziDisponibili.isEmpty) return;

    Esercizio esercizioScelto = eserciziDisponibili.first;
    final serieCtrl = TextEditingController(text: '3');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Aggiungi esercizio alla sessione'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: esercizioScelto.id,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Esercizio',
                    ),
                    items: eserciziDisponibili.map((es) {
                      return DropdownMenuItem(
                        value: es.id,
                        child: Text(
                          '${es.nome} (${es.categoria})',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (nuovoId) {
                      if (nuovoId == null) return;
                      setStateDialog(() {
                        esercizioScelto = eserciziDisponibili.firstWhere(
                          (e) => e.id == nuovoId,
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: serieCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Numero di serie',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Annulla'),
                ),
                FilledButton(
                  onPressed: () {
                    final numSerie = int.tryParse(serieCtrl.text.trim()) ?? 3;
                    final nuovoEsercizio = EsercizioSvolto(
                      esercizioId: esercizioScelto.id,
                      nomeEsercizio: esercizioScelto.nome,
                      serie: List.generate(
                        numSerie > 0 ? numSerie : 1,
                        (_) => const SerieSvolta(),
                      ),
                    );

                    final listaAggiornata = [
                      ...registro.esercizi,
                      nuovoEsercizio,
                    ];
                    provider.aggiornaRegistro(
                      registro.copyWith(esercizi: listaAggiornata),
                    );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Aggiungi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _aggiornaSerie({
    required AllenamentoProvider provider,
    required RegistroAllenamento registro,
    required int indiceEsercizio,
    required int indiceSerie,
    required SerieSvolta nuovaSerie,
  }) {
    final eserciziAggiornati = List<EsercizioSvolto>.from(registro.esercizi);
    final esercizioCorrente = eserciziAggiornati[indiceEsercizio];
    final serieAggiornate = List<SerieSvolta>.from(esercizioCorrente.serie);

    serieAggiornate[indiceSerie] = nuovaSerie;
    eserciziAggiornati[indiceEsercizio] = esercizioCorrente.copyWith(
      serie: serieAggiornate,
    );

    provider.aggiornaRegistro(
      registro.copyWith(esercizi: eserciziAggiornati),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AllenamentoProvider>();
    final indiceRegistro = provider.registri.indexWhere(
      (r) => r.id == widget.registroId,
    );

    if (indiceRegistro == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sessione')),
        body: const Center(child: Text('Allenamento non trovato.')),
      );
    }

    final registro = provider.registri[indiceRegistro];
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(registro.titolo),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: () async {
                await provider.aggiornaRegistro(
                  registro.copyWith(completato: true),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Allenamento salvato nello storico!'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.flag_rounded),
              label: Text(registro.completato ? 'Salva' : 'Termina'),
            ),
          ),
        ],
      ),
      body: registro.esercizi.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 48,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sessione libera vuota.\nPremi "+ Aggiungi esercizio" per iniziare a registrare.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: registro.esercizi.length,
              itemBuilder: (context, idxEs) {
                final esercizio = registro.esercizi[idxEs];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                esercizio.nomeEsercizio,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Rimuovi esercizio dalla sessione',
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _svuotaControllers();
                                final lista = List<EsercizioSvolto>.from(
                                  registro.esercizi,
                                )..removeAt(idxEs);
                                provider.aggiornaRegistro(
                                  registro.copyWith(esercizi: lista),
                                );
                              },
                            ),
                          ],
                        ),
                        if (esercizio.note.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Note: ${esercizio.note}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        const Divider(),
                        // Intestazione colonne
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 42,
                                child: Text(
                                  'Serie',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Peso (kg)',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Ripetizioni',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 44,
                                child: Center(
                                  child: Text(
                                    'Fatto',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Righe delle singole serie
                        ...List.generate(esercizio.serie.length, (idxSerie) {
                          final serie = esercizio.serie[idxSerie];
                          final precedente = provider.suggerimentoPrecedente(
                            esercizioId: esercizio.esercizioId,
                            indiceSerie: idxSerie,
                            escludiRegistroId: registro.id,
                          );

                          // Valore suggerito in trasparenza: priorità allo storico reale,
                          // altrimenti l'eventuale target impostato nella scheda
                          final double? pesoSuggerito =
                              (precedente != null && precedente.peso > 0)
                                  ? precedente.peso
                                  : (serie.peso > 0 ? serie.peso : null);

                          final int? repSuggerite =
                              (precedente != null && precedente.ripetizioni > 0)
                                  ? precedente.ripetizioni
                                  : (serie.ripetizioni > 0
                                      ? serie.ripetizioni
                                      : null);

                          final pesoCtrl = _ottieniController(
                            '${idxEs}_${esercizio.esercizioId}_${idxSerie}_peso',
                            serie.completata && serie.peso > 0
                                ? _formattaPeso(serie.peso)
                                : '',
                          );

                          final repCtrl = _ottieniController(
                            '${idxEs}_${esercizio.esercizioId}_${idxSerie}_rep',
                            serie.completata && serie.ripetizioni > 0
                                ? serie.ripetizioni.toString()
                                : '',
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 42,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: serie.completata
                                        ? colorScheme.primaryContainer
                                        : colorScheme.surfaceContainerHighest,
                                    child: Text(
                                      '${idxSerie + 1}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: serie.completata
                                            ? colorScheme.onPrimaryContainer
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: pesoCtrl,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: pesoSuggerito != null
                                          ? _formattaPeso(pesoSuggerito)
                                          : '0',
                                      hintStyle: TextStyle(
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.38),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      final pesoInserito = double.tryParse(
                                            val.trim().replaceAll(',', '.'),
                                          ) ??
                                          0;
                                      _aggiornaSerie(
                                        provider: provider,
                                        registro: registro,
                                        indiceEsercizio: idxEs,
                                        indiceSerie: idxSerie,
                                        nuovaSerie: serie.copyWith(
                                          peso: pesoInserito,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: repCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: repSuggerite != null
                                          ? repSuggerite.toString()
                                          : '10',
                                      hintStyle: TextStyle(
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.38),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      final repInserite =
                                          int.tryParse(val.trim()) ?? 0;
                                      _aggiornaSerie(
                                        provider: provider,
                                        registro: registro,
                                        indiceEsercizio: idxEs,
                                        indiceSerie: idxSerie,
                                        nuovaSerie: serie.copyWith(
                                          ripetizioni: repInserite,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 44,
                                  child: Checkbox(
                                    value: serie.completata,
                                    onChanged: (spuntata) {
                                      final nuovoStato = spuntata ?? false;
                                      double pesoFinale = double.tryParse(
                                            pesoCtrl.text
                                                .trim()
                                                .replaceAll(',', '.'),
                                          ) ??
                                          0;
                                      int repFinali =
                                          int.tryParse(repCtrl.text.trim()) ??
                                              0;

                                      // Se l'utente spunta la serie senza scrivere, adotta il suggerimento in trasparenza
                                      if (nuovoStato) {
                                        if (pesoCtrl.text.trim().isEmpty &&
                                            pesoSuggerito != null) {
                                          pesoFinale = pesoSuggerito;
                                          pesoCtrl.text =
                                              _formattaPeso(pesoFinale);
                                        }
                                        if (repCtrl.text.trim().isEmpty &&
                                            repSuggerite != null) {
                                          repFinali = repSuggerite;
                                          repCtrl.text = repFinali.toString();
                                        }
                                      }

                                      _aggiornaSerie(
                                        provider: provider,
                                        registro: registro,
                                        indiceEsercizio: idxEs,
                                        indiceSerie: idxSerie,
                                        nuovaSerie: serie.copyWith(
                                          peso: pesoFinale,
                                          ripetizioni: repFinali,
                                          completata: nuovoStato,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (esercizio.serie.length > 1)
                              TextButton.icon(
                                onPressed: () {
                                  _svuotaControllers();
                                  final serieAggiornate =
                                      List<SerieSvolta>.from(esercizio.serie)
                                        ..removeLast();
                                  final eserciziAggiornati =
                                      List<EsercizioSvolto>.from(
                                    registro.esercizi,
                                  );
                                  eserciziAggiornati[idxEs] =
                                      esercizio.copyWith(
                                    serie: serieAggiornate,
                                  );
                                  provider.aggiornaRegistro(
                                    registro.copyWith(
                                      esercizi: eserciziAggiornati,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.remove, size: 18),
                                label: const Text('Togli serie'),
                              ),
                            TextButton.icon(
                              onPressed: () {
                                final serieAggiornate =
                                    List<SerieSvolta>.from(esercizio.serie)
                                      ..add(const SerieSvolta());
                                final eserciziAggiornati =
                                    List<EsercizioSvolto>.from(
                                  registro.esercizi,
                                );
                                eserciziAggiornati[idxEs] = esercizio.copyWith(
                                  serie: serieAggiornate,
                                );
                                provider.aggiornaRegistro(
                                  registro.copyWith(
                                    esercizi: eserciziAggiornati,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Aggiungi serie'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostraDialogAggiungiEsercizio(context, registro),
        icon: const Icon(Icons.add),
        label: const Text('Aggiungi esercizio'),
      ),
    );
  }
}