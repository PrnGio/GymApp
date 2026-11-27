import 'package:flutter/material.dart';
import 'schermata_registro.dart';
import 'schermata_schede.dart';
import 'schermata_esercizi.dart';

class StrutturaPrincipale extends StatefulWidget {
  const StrutturaPrincipale({super.key});

  @override
  State<StrutturaPrincipale> createState() => _StrutturaPrincipaleState();
}

class _StrutturaPrincipaleState extends State<StrutturaPrincipale> {
  int _indiceSelezionato = 0;

  static const List<String> _titoli = [
    'Registro Allenamenti',
    'Le mie Schede',
    'Catalogo Esercizi',
  ];

  static const List<Widget> _schermate = [
    SchermataRegistro(),
    SchermataSchede(),
    SchermataEsercizi(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSchermoGrande = constraints.maxWidth >= 600;

        return Scaffold(
          appBar: AppBar(
            title: Text(_titoli[_indiceSelezionato]),
            actions: [
              IconButton(
                tooltip: 'Sincronizza con il cloud',
                icon: const Icon(Icons.sync),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sincronizzazione pronta nella Fase 3'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: isSchermoGrande
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _indiceSelezionato,
                      onDestinationSelected: (index) {
                        setState(() => _indiceSelezionato = index);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.calendar_today_outlined),
                          selectedIcon: Icon(Icons.calendar_today),
                          label: Text('Registro'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.list_alt_outlined),
                          selectedIcon: Icon(Icons.list_alt),
                          label: Text('Schede'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.fitness_center_outlined),
                          selectedIcon: Icon(Icons.fitness_center),
                          label: Text('Esercizi'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: _schermate[_indiceSelezionato]),
                  ],
                )
              : _schermate[_indiceSelezionato],
          bottomNavigationBar: isSchermoGrande
              ? null
              : NavigationBar(
                  selectedIndex: _indiceSelezionato,
                  onDestinationSelected: (index) {
                    setState(() => _indiceSelezionato = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.calendar_today_outlined),
                      selectedIcon: Icon(Icons.calendar_today),
                      label: 'Registro',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.list_alt_outlined),
                      selectedIcon: Icon(Icons.list_alt),
                      label: 'Schede',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.fitness_center_outlined),
                      selectedIcon: Icon(Icons.fitness_center),
                      label: 'Esercizi',
                    ),
                  ],
                ),
        );
      },
    );
  }
}