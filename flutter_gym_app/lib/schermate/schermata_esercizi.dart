import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelli/esercizio.dart';
import '../stati/allenamento_provider.dart';

class SchermataEsercizi extends StatefulWidget {
  const SchermataEsercizi({super.key});

  @override
  State<SchermataEsercizi> createState() => _SchermataEserciziState();
}

class _SchermataEserciziState extends State<SchermataEsercizi> {
  String _categoriaSelezionata = 'Tutte';

  void _mostraDialogNuovoEsercizio(BuildContext context) {
    final controllerNome = TextEditingController();
    String categoriaScelta = Esercizio.categorieDisponibili.first;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nuovo Esercizio'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controllerNome,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nome esercizio',
                      hintText: 'Es. Hip Thrust bilanciere',
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: categoriaScelta,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                    ),
                    items: Esercizio.categorieDisponibili
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ),
                        )
                        .toList(),
                    onChanged: (valore) {
                      if (valore != null) {
                        setStateDialog(() => categoriaScelta = valore);
                      }
                    },
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
                    final nome = controllerNome.text.trim();
                    if (nome.isEmpty) return;

                    context.read<AllenamentoProvider>().aggiungiEsercizio(
                          nome: nome,
                          categoria: categoriaScelta,
                        );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Salva'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AllenamentoProvider>();

    if (provider.inCaricamento) {
      return const Center(child: CircularProgressIndicator());
    }

    final categorie = ['Tutte', ...Esercizio.categorieDisponibili];
    final eserciziFiltrati = _categoriaSelezionata == 'Tutte'
        ? provider.esercizi
        : provider.esercizi
            .where((e) => e.categoria == _categoriaSelezionata)
            .toList();

    return Scaffold(
      body: Column(
        children: [
          // Barra filtri per categoria
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: categorie.map((cat) {
                final selezionata = cat == _categoriaSelezionata;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selezionata,
                    onSelected: (_) {
                      setState(() => _categoriaSelezionata = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Lista esercizi
          Expanded(
            child: eserciziFiltrati.isEmpty
                ? const Center(
                    child: Text('Nessun esercizio in questa categoria.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                    itemCount: eserciziFiltrati.length,
                    itemBuilder: (context, index) {
                      final esercizio = eserciziFiltrati[index];
                      final isPersonalizzato =
                          !esercizio.id.startsWith('def_');

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: const CircleAvatar(
                            child: Icon(Icons.fitness_center),
                          ),
                          title: Text(
                            esercizio.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(esercizio.categoria),
                          trailing: isPersonalizzato
                              ? IconButton(
                                  tooltip: 'Elimina esercizio',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    provider.eliminaEsercizio(esercizio.id);
                                  },
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostraDialogNuovoEsercizio(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuovo esercizio'),
      ),
    );
  }
}