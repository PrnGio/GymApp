import 'package:flutter/material.dart';

class SchermataEsercizi extends StatelessWidget {
  const SchermataEsercizi({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const CircleAvatar(
              child: Icon(Icons.fitness_center),
            ),
            title: const Text(
              'Panca Piana Bilanciere',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Categoria: Busto'),
          ),
        ),
      ],
    );
  }
}