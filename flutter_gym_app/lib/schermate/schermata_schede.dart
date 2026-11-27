import 'package:flutter/material.dart';

class SchermataSchede extends StatelessWidget {
  const SchermataSchede({super.key});

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
              child: Icon(Icons.assignment_outlined),
            ),
            title: const Text(
              'Scheda A — Spinta (esempio)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('4 esercizi • Ultima modifica oggi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}