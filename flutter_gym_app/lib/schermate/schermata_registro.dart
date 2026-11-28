import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelli/registro_allenamento.dart';
import '../stati/allenamento_provider.dart';
import 'schermata_sessione_attiva.dart';

class SchermataRegistro extends StatelessWidget {
  const SchermataRegistro({super.key});

  void _apriSessione(BuildContext context, String registroId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SchermataSessioneAttiva(registroId: registroId),
      ),
    );
  }

  void _mostraSceltaScheda(BuildContext context) {
    final provider = context.read<AllenamentoProvider>();
    final schede = provider.schede;

    if (schede.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Non hai ancora schede salvate. Creane una nel tab Schede oppure avvia una sessione libera!',
          ),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: schede.length,
          itemBuilder: (context, index) {
            final scheda = schede[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.play_arrow_rounded),
                ),
                title: Text(
                  scheda.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${scheda.voci.length} esercizi'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final nuovoRegistro =
                      await provider.avviaAllenamentoDaScheda(scheda);
                  if (context.mounted) {
                    _apriSessione(context, nuovoRegistro.id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  String _formattaData(int timestampMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final giorno = dt.day.toString().padLeft(2, '0');
    final mese = dt.month.toString().padLeft(2, '0');
    final anno = dt.year;
    final ora = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$giorno/$mese/$anno • $ora:$min';
  }

  void _confermaEliminazione(
    BuildContext context,
    RegistroAllenamento registro,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Elimina allenamento'),
        content: Text('Vuoi eliminare "${registro.titolo}" dallo storico?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              context
                  .read<AllenamentoProvider>()
                  .eliminaRegistro(registro.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AllenamentoProvider>();

    if (provider.inCaricamento) {
      return const Center(child: CircularProgressIndicator());
    }

    final registri = provider.registri;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Riquadro avvio rapido
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avvio rapido',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Scegli una scheda salvata oppure registra esercizi singoli al volo.',
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _mostraSceltaScheda(context),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Avvia da scheda'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final nuovo =
                            await provider.avviaAllenamentoLibero();
                        if (context.mounted) {
                          _apriSessione(context, nuovo.id);
                        }
                      },
                      icon: const Icon(Icons.bolt_rounded),
                      label: const Text('Sessione libera'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Storico allenamenti (${registri.length})',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        if (registri.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Nessun allenamento registrato.\nAvvia la tua prima sessione qui sopra!',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ...registri.map((registro) {
            final riepilogoEsercizi = registro.esercizi
                .take(3)
                .map((e) => e.nomeEsercizio)
                .join(', ');

            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  backgroundColor: registro.completato
                      ? colorScheme.primaryContainer
                      : colorScheme.tertiaryContainer,
                  child: Icon(
                    registro.completato
                        ? Icons.check_rounded
                        : Icons.timelapse_rounded,
                    color: registro.completato
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onTertiaryContainer,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        registro.titolo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (!registro.completato)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'In corso',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(_formattaData(registro.dataInizio)),
                    if (riepilogoEsercizi.isNotEmpty)
                      Text(
                        riepilogoEsercizi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
                onTap: () => _apriSessione(context, registro.id),
                trailing: IconButton(
                  tooltip: 'Elimina dallo storico',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confermaEliminazione(context, registro),
                ),
              ),
            );
          }),
      ],
    );
  }
}