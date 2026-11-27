import 'package:flutter/material.dart';
import 'tema/tema_app.dart';

void main() {
  runApp(const GymApp());
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymApp',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaChiaro,
      darkTheme: TemaApp.temaScuro,
      themeMode: ThemeMode.system, // Segue il tema chiaro/scuro del dispositivo
      home: const SchermataTestTema(),
    );
  }
}

class SchermataTestTema extends StatelessWidget {
  const SchermataTestTema({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GymApp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panca Piana Bilanciere',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Busto • 4 serie x 8 ripetizioni'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.fitness_center),
              label: const Text('Tema attivo!'),
            ),
          ],
        ),
      ),
    );
  }
}