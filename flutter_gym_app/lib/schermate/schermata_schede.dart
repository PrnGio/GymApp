import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelli/scheda_allenamento.dart';
import '../stati/allenamento_provider.dart';
import 'schermata_modifica_scheda.dart';
import 'schermata_sessione_attiva.dart';

class SchermataSchede extends StatelessWidget {
  const SchermataSchede({super.key});

  void _apriEditor(BuildContext context, [SchedaAllenamento? scheda]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SchermataModificaScheda(schedaEsistente: scheda),
      ),
    );
  }

  void _confermaEliminazione(
    BuildContext context,
    SchedaAllenamento scheda,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Elimina scheda'),
        content: Text('Vuoi eliminare "${scheda.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AllenamentoProvider>().eliminaScheda(scheda.id);
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

    final schede = provider.schede;

    return Scaffold(
      body: schede.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list_alt_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nessuna scheda salvata',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Crea la tua prima scheda di allenamento con serie, ripetizioni, peso e note.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
              itemCount: schede.length,
              itemBuilder: (context, index) {
                final scheda = schede[index];
                final anteprimaEsercizi = scheda.voci
                    .take(3)
                    .map((v) => v.nomeEsercizio)
                    .join(', ');

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _apriEditor(context, scheda),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      scheda.nome,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${scheda.voci.length} esercizi${anteprimaEsercizi.isNotEmpty ? ' • $anteprimaEsercizi' : ''}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Modifica scheda',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _apriEditor(context, scheda),
                            ),
                            IconButton(
                              tooltip: 'Elimina scheda',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () =>
                                  _confermaEliminazione(context, scheda),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.tonalIcon(
                            onPressed: () async {
                              final nuovoRegistro = await provider
                                  .avviaAllenamentoDaScheda(scheda);
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SchermataSessioneAttiva(
                                      registroId: nuovoRegistro.id,
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Avvia allenamento'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _apriEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuova scheda'),
      ),
    );
  }
}