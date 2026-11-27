import 'entita_sincronizzabile.dart';

class VoceScheda {
  final String esercizioId;
  final String nomeEsercizio;
  final int serie;
  final int ripetizioni;
  final double pesoTarget;
  final String note;

  const VoceScheda({
    required this.esercizioId,
    required this.nomeEsercizio,
    required this.serie,
    required this.ripetizioni,
    this.pesoTarget = 0,
    this.note = '',
  });

  VoceScheda copyWith({
    String? esercizioId,
    String? nomeEsercizio,
    int? serie,
    int? ripetizioni,
    double? pesoTarget,
    String? note,
  }) {
    return VoceScheda(
      esercizioId: esercizioId ?? this.esercizioId,
      nomeEsercizio: nomeEsercizio ?? this.nomeEsercizio,
      serie: serie ?? this.serie,
      ripetizioni: ripetizioni ?? this.ripetizioni,
      pesoTarget: pesoTarget ?? this.pesoTarget,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
        'esercizioId': esercizioId,
        'nomeEsercizio': nomeEsercizio,
        'serie': serie,
        'ripetizioni': ripetizioni,
        'pesoTarget': pesoTarget,
        'note': note,
      };

  factory VoceScheda.fromJson(Map<String, dynamic> json) => VoceScheda(
        esercizioId: json['esercizioId'] as String,
        nomeEsercizio: json['nomeEsercizio'] as String,
        serie: json['serie'] as int? ?? 3,
        ripetizioni: json['ripetizioni'] as int? ?? 10,
        pesoTarget: (json['pesoTarget'] as num?)?.toDouble() ?? 0,
        note: json['note'] as String? ?? '',
      );
}

class SchedaAllenamento extends EntitaSincronizzabile {
  final String nome;
  final List<VoceScheda> voci;

  const SchedaAllenamento({
    required super.id,
    required super.ultimaModifica,
    super.eliminato,
    super.sincronizzato,
    required this.nome,
    required this.voci,
  });

  SchedaAllenamento copyWith({
    String? nome,
    List<VoceScheda>? voci,
    int? ultimaModifica,
    bool? eliminato,
    bool? sincronizzato,
  }) {
    return SchedaAllenamento(
      id: id,
      nome: nome ?? this.nome,
      voci: voci ?? this.voci,
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
        'voci': voci.map((v) => v.toJson()).toList(),
      };

  factory SchedaAllenamento.fromJson(Map<String, dynamic> json) =>
      SchedaAllenamento(
        id: json['id'] as String,
        ultimaModifica: json['ultimaModifica'] as int? ?? 0,
        eliminato: json['eliminato'] as bool? ?? false,
        sincronizzato: json['sincronizzato'] as bool? ?? true,
        nome: json['nome'] as String,
        voci: (json['voci'] as List<dynamic>? ?? [])
            .map((e) => VoceScheda.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}