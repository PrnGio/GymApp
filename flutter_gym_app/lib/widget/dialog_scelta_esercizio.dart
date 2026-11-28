// mostra i chip filtro in alto e gli esercizi divisi sotto l'intestazione della propria categoria

import 'package:flutter/material.dart';
import '../modelli/esercizio.dart';

class DialogSceltaEsercizio extends StatefulWidget {
  final List<Esercizio> esercizi;
  final String? esercizioSelezionatoId;

  const DialogSceltaEsercizio({
    super.key,
    required this.esercizi,
    this.esercizioSelezionatoId,
  });

  static Future<Esercizio?> mostra(
    BuildContext context, {
    required List<Esercizio> esercizi,
    String? esercizioSelezionatoId,
  }) {
    return showDialog<Esercizio>(
      context: context,
      builder: (_) => DialogSceltaEsercizio(
        esercizi: esercizi,
        esercizioSelezionatoId: esercizioSelezionatoId,
      ),
    );
  }

  @override
  State<DialogSceltaEsercizio> createState() => _DialogSceltaEsercizioState();
}

class _DialogSceltaEsercizioState extends State<DialogSceltaEsercizio> {
  String _categoriaFiltro = 'Tutte';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categorieFiltro = ['Tutte', ...Esercizio.categorieDisponibili];

    final categorieDaMostrare = _categoriaFiltro == 'Tutte'
        ? Esercizio.categorieDisponibili
        : [_categoriaFiltro];

    // Costruisce la lista raggruppata per categoria
    final List<Widget> elementiRaggruppati = [];
    for (final categoria in categorieDaMostrare) {
      final eserciziCategoria = widget.esercizi
          .where((e) => e.categoria == categoria)
          .toList();

      if (eserciziCategoria.isEmpty) continue;

      elementiRaggruppati.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
          child: Row(
            children: [
              Icon(
                Icons.label_important_outline,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                categoria.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      );

      for (final esercizio in eserciziCategoria) {
        final isSelezionato = esercizio.id == widget.esercizioSelezionatoId;
        elementiRaggruppati.add(
          Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            color: isSelezionato ? colorScheme.primaryContainer : null,
            child: ListTile(
              dense: true,
              title: Text(
                esercizio.nome,
                style: TextStyle(
                  fontWeight:
                      isSelezionato ? FontWeight.bold : FontWeight.w500,
                  color: isSelezionato
                      ? colorScheme.onPrimaryContainer
                      : null,
                ),
              ),
              trailing: isSelezionato
                  ? Icon(Icons.check, color: colorScheme.onPrimaryContainer)
                  : const Icon(Icons.chevron_right, size: 18),
              onTap: () => Navigator.pop(context, esercizio),
            ),
          ),
        );
      }
    }

    return AlertDialog(
      title: const Text('Scegli esercizio'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 460),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: categorieFiltro.map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: _categoriaFiltro == cat,
                    visualDensity: VisualDensity.compact,
                    onSelected: (_) {
                      setState(() => _categoriaFiltro = cat);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: elementiRaggruppati.isEmpty
                    ? const Center(
                        child: Text('Nessun esercizio in questa categoria.'),
                      )
                    : ListView(children: elementiRaggruppati),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Chiudi'),
        ),
      ],
    );
  }
}