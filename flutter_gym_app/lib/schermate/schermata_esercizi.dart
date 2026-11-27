import 'package:flutter/material.dart';
import '../modelli/esercizio.dart';

class SchermataEsercizi extends StatelessWidget {
  const SchermataEsercizi({super.key});

  @override
  Widget build(BuildContext context) {
    final esercizi = Esercizio.eserciziPredefiniti;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: esercizi.length,
      itemBuilder: (context, index) {
        final esercizio = esercizi[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: const CircleAvatar(
              child: Icon(Icons.fitness_center),
            ),
            title: Text(
              esercizio.nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Categoria: ${esercizio.categoria}'),
          ),
        );
      },
    );
  }
}