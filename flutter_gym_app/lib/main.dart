import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tema/tema_app.dart';
import 'servizi/memoria_locale_servizio.dart';
import 'stati/allenamento_provider.dart';
import 'schermate/struttura_principale.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GymApp());
}

class GymApp extends StatelessWidget {
  const GymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AllenamentoProvider(MemoriaLocaleServizio())..inizializza(),
      child: MaterialApp(
        title: 'GymApp',
        debugShowCheckedModeBanner: false,
        theme: TemaApp.temaChiaro,
        darkTheme: TemaApp.temaScuro,
        themeMode: ThemeMode.system,
        home: const StrutturaPrincipale(),
      ),
    );
  }
}