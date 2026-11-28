import 'entita_sincronizzabile.dart';

class Esercizio extends EntitaSincronizzabile {
  final String nome;
  final String categoria;

  const Esercizio({
    required super.id,
    required super.ultimaModifica,
    super.eliminato,
    super.sincronizzato,
    required this.nome,
    required this.categoria,
  });

  static const List<String> categorieDisponibili = [
    'Petto',
    'Schiena',
    'Gambe',
    'Spalle',
    'Braccia',
    'Addome',
  ];

  Esercizio copyWith({
    String? nome,
    String? categoria,
    int? ultimaModifica,
    bool? eliminato,
    bool? sincronizzato,
  }) {
    return Esercizio(
      id: id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      ultimaModifica: ultimaModifica ?? this.ultimaModifica,
      eliminato: eliminato ?? this.eliminato,
      sincronizzato: sincronizzato ?? this.sincronizzato,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ultimaModifica': ultimaModifica,
        'eliminato': eliminato,
        'sincronizzato': sincronizzato,
        'nome': nome,
        'categoria': categoria,
      };

  factory Esercizio.fromJson(Map<String, dynamic> json) => Esercizio(
        id: json['id'] as String,
        ultimaModifica: json['ultimaModifica'] as int? ?? 0,
        eliminato: json['eliminato'] as bool? ?? false,
        sincronizzato: json['sincronizzato'] as bool? ?? true,
        nome: json['nome'] as String,
        categoria: json['categoria'] as String,
      );

  /// Catalogo base precaricato al primo avvio
  static List<Esercizio> get eserciziPredefiniti => const [
        Esercizio(id: 'def_panca_piana', ultimaModifica: 1, sincronizzato: true, nome: 'Panca Piana Bilanciere', categoria: 'Busto'),
        Esercizio(id: 'def_spinte_manubri', ultimaModifica: 1, sincronizzato: true, nome: 'Spinte Manubri Panca Inclinata', categoria: 'Busto'),
        Esercizio(id: 'def_croci_cavi', ultimaModifica: 1, sincronizzato: true, nome: 'Croci ai Cavi', categoria: 'Busto'),
        Esercizio(id: 'def_lat_machine', ultimaModifica: 1, sincronizzato: true, nome: 'Lat Machine Avanti', categoria: 'Schiena'),
        Esercizio(id: 'def_rematore', ultimaModifica: 1, sincronizzato: true, nome: 'Rematore con Manubrio', categoria: 'Schiena'),
        Esercizio(id: 'def_pulley', ultimaModifica: 1, sincronizzato: true, nome: 'Pulley Basso', categoria: 'Schiena'),
        Esercizio(id: 'def_squat', ultimaModifica: 1, sincronizzato: true, nome: 'Squat con Bilanciere', categoria: 'Gambe'),
        Esercizio(id: 'def_leg_press', ultimaModifica: 1, sincronizzato: true, nome: 'Leg Press 45°', categoria: 'Gambe'),
        Esercizio(id: 'def_leg_curl', ultimaModifica: 1, sincronizzato: true, nome: 'Leg Curl Sdraiato', categoria: 'Gambe'),
        Esercizio(id: 'def_military_press', ultimaModifica: 1, sincronizzato: true, nome: 'Military Press', categoria: 'Spalle'),
        Esercizio(id: 'def_alzate_laterali', ultimaModifica: 1, sincronizzato: true, nome: 'Alzate Laterali Manubri', categoria: 'Spalle'),
        Esercizio(id: 'def_curl_bilanciere', ultimaModifica: 1, sincronizzato: true, nome: 'Curl con Bilanciere', categoria: 'Braccia'),
        Esercizio(id: 'def_pushdown_cavi', ultimaModifica: 1, sincronizzato: true, nome: 'Pushdown Tricipiti ai Cavi', categoria: 'Braccia'),
        Esercizio(id: 'def_plank', ultimaModifica: 1, sincronizzato: true, nome: 'Plank', categoria: 'Addome'),
        Esercizio(id: 'def_crunch', ultimaModifica: 1, sincronizzato: true, nome: 'Crunch a Terra', categoria: 'Addome'),
      ];
}