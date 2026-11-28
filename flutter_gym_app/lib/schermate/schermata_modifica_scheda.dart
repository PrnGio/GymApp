// Questa schermata permette di creare una nuova scheda (o modificarne una esistente),
//aggiungere esercizi dal catalogo e impostare per ognuno serie, ripetizioni, peso target e note
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelli/esercizio.dart';
import '../modelli/scheda_allenamento.dart';
import '../stati/allenamento_provider.dart';
import '../widget/dialog_scelta_esercizio.dart';

class SchermataModificaScheda extends StatefulWidget {
  final SchedaAllenamento? schedaEsistente;

  const SchermataModificaScheda({super.key, this.schedaEsistente});

  @override
  State<SchermataModificaScheda> createState() =>
      _SchermataModificaSchedaState();
}

class _SchermataModificaSchedaState extends State<SchermataModificaScheda> {
  late final TextEditingController _nomeSchedaController;
  late List<VoceScheda> _voci;

  @override
  void initState() {
    super.initState();
    _nomeSchedaController = TextEditingController(
      text: widget.schedaEsistente?.nome ?? '',
    );
    _voci = List<VoceScheda>.from(widget.schedaEsistente?.voci ?? []);
  }

  @override
  void dispose() {
    _nomeSchedaController.dispose();
    super.dispose();
  }

  void _mostraDialogVoce({VoceScheda? voceEsistente, int? indiceModifica}) {
    final eserciziDisponibili = context.read<AllenamentoProvider>().esercizi;
    if (eserciziDisponibili.isEmpty) return;

    Esercizio esercizioScelto = eserciziDisponibili.firstWhere(
      (e) => e.id == voceEsistente?.esercizioId,
      orElse: () => eserciziDisponibili.first,
    );

    final serieCtrl = TextEditingController(
      text: (voceEsistente?.serie ?? 3).toString(),
    );
    final repCtrl = TextEditingController(
      text: (voceEsistente?.ripetizioni ?? 10).toString(),
    );
    final pesoCtrl = TextEditingController(
      text: voceEsistente != null && voceEsistente.pesoTarget > 0
          ? _formattaPeso(voceEsistente.pesoTarget)
          : '',
    );
    final noteCtrl = TextEditingController(text: voceEsistente?.note ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                voceEsistente == null
                    ? 'Aggiungi Esercizio'
                    : 'Modifica Esercizio',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final scelto = await DialogSceltaEsercizio.mostra(
                            context,
                            esercizi: eserciziDisponibili,
                            esercizioSelezionatoId: esercizioScelto.id,
                          );
                          if (scelto != null) {
                            setStateDialog(() => esercizioScelto = scelto);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Esercizio',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          child: Text(
                            '${esercizioScelto.nome} (${esercizioScelto.categoria})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: serieCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Serie',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: repCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Ripetizioni',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pesoCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Peso target (kg) — opzionale',
                        hintText: 'Es. 60 o 12.5',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Note — opzionali',
                        hintText: 'Es. Recupero 90s, fermo al petto',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Annulla'),
                ),
                FilledButton(
                  onPressed: () {
                    final serie = int.tryParse(serieCtrl.text.trim()) ?? 3;
                    final rep = int.tryParse(repCtrl.text.trim()) ?? 10;
                    final peso = double.tryParse(
                          pesoCtrl.text.trim().replaceAll(',', '.'),
                        ) ??
                        0;

                    final nuovaVoce = VoceScheda(
                      esercizioId: esercizioScelto.id,
                      nomeEsercizio: esercizioScelto.nome,
                      serie: serie > 0 ? serie : 1,
                      ripetizioni: rep > 0 ? rep : 1,
                      pesoTarget: peso >= 0 ? peso : 0,
                      note: noteCtrl.text.trim(),
                    );

                    setState(() {
                      if (indiceModifica != null) {
                        _voci[indiceModifica] = nuovaVoce;
                      } else {
                        _voci.add(nuovaVoce);
                      }
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Conferma'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _salvaScheda() async {
    final nome = _nomeSchedaController.text.trim();
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci un nome per la scheda.')),
      );
      return;
    }

    if (_voci.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aggiungi almeno un esercizio alla scheda.'),
        ),
      );
      return;
    }

    await context.read<AllenamentoProvider>().salvaScheda(
          idEsistente: widget.schedaEsistente?.id,
          nome: nome,
          voci: _voci,
        );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  String _formattaPeso(double peso) {
    return peso % 1 == 0 ? peso.toInt().toString() : peso.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isModifica = widget.schedaEsistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isModifica ? 'Modifica Scheda' : 'Nuova Scheda'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: _salvaScheda,
              icon: const Icon(Icons.check),
              label: const Text('Salva'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          TextField(
            controller: _nomeSchedaController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Nome scheda',
              hintText: 'Es. Scheda A — Spinta',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Esercizi (${_voci.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              OutlinedButton.icon(
                onPressed: () => _mostraDialogVoce(),
                icon: const Icon(Icons.add),
                label: const Text('Aggiungi esercizio'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_voci.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 36,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nessun esercizio inserito.\nPremi "Aggiungi esercizio" per comporre la scheda.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(_voci.length, (index) {
              final voce = _voci[index];
              final dettaglioPeso = voce.pesoTarget > 0
                  ? ' • ${_formattaPeso(voce.pesoTarget)} kg'
                  : '';

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    voce.nomeEsercizio,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${voce.serie} serie x ${voce.ripetizioni} rep$dettaglioPeso'),
                      if (voce.note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Note: ${voce.note}',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () => _mostraDialogVoce(
                    voceEsistente: voce,
                    indiceModifica: index,
                  ),
                  trailing: IconButton(
                    tooltip: 'Rimuovi dalla scheda',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      setState(() => _voci.removeAt(index));
                    },
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}