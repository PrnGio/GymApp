import 'package:flutter/material.dart';
import 'tema/tema_app.dart';
import 'schermate/struttura_principale.dart';

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
      themeMode: ThemeMode.system,
      home: const StrutturaPrincipale(),
    );
  }
}