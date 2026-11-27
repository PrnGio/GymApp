import 'entita_sincronizzabile.dart';

class SerieSvolta {
  final int ripetizioni;
  final double peso;
  final bool completata;

  const SerieSvolta({
    this.ripetizioni = 0,
    this.peso = 0,
    this.completata = false,
  });

  SerieSvolta copyWith({
    int? ripetizioni,
    double? peso,
    bool? completata,
  }) {
    return SerieSvolta(
      ripetizioni: ripetizioni ?? this.ripetizioni,
      peso: peso ?? this.peso,
      completata: completata ?? this.completata,
    );
  }

  Map<String, dynamic> toJson() => {
        'ripetizioni': ripetizioni,
        'peso': peso,
        'completata': completata,
      };

  factory SerieSvolta.fromJson(Map<String, dynamic> json) => SerieSvolta(
        ripetizioni: json['ripetizioni'] as int? ?? 0,
        peso: (json['peso'] as num?)?.toDouble() ?? 0,
        completata: json['completata'] as bool? ?? false,
      );
}

class EsercizioSvolto {
  final String esercizioId;
  final String nomeEsercizio;
  final String note;
  final List<SerieSvolta> serie;

  const EsercizioSvolto({
    required this.esercizioId,
    required this.nomeEsercizio,
    this.note = '',
    required this.serie,
  });

  EsercizioSvolto copyWith({
    String? esercizioId,
    String? nomeEsercizio,
    String? note,
    List<SerieSvolta>? serie,
  }) {
    return EsercizioSvolto(
      esercizioId: esercizioId ?? this.esercizioId,
      nomeEsercizio: nomeEsercizio ?? this.nomeEsercizio,
      note: note ?? this.note,
      serie: serie ?? this.serie,
    );
  }

  Map<String, dynamic> toJson() => {
        'esercizioId': esercizioId,
        'nomeEsercizio': nomeEsercizio,
        'note': note,
        'serie': serie.map((s) => s.toJson()).toList(),
      };

  factory EsercizioSvolto.fromJson(Map<String, dynamic> json) =>
      EsercizioSvolto(
        esercizioId: json['esercizioId'] as String,
        nomeEsercizio: json['nomeEsercizio'] as String,
        note: json['note'] as String? ?? '',
        serie: (json['serie'] as List<dynamic>? ?? [])
            .map((e) => SerieSvolta.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class RegistroAllenamento extends EntitaSincronizzabile {
  final String titolo;
  final String? schedaOrigineId; // null se allenamento libero
  final int dataInizio; // Timestamp in millisecondi
  final bool completato;
  final List<EsercizioSvolto> esercizi;

  const RegistroAllenamento({
    required super.id,
    required super.ultimaModifica,
    super.eliminato,
    super.sincronizzato,
    required this.titolo,
    this.schedaOrigineId,
    required this.dataInizio,
    this.completato = false,
    required this.esercizi,
  });

  RegistroAllenamento copyWith({
    String? titolo,
    String? schedaOrigineId,
    int? dataInizio,
    bool? completato,
    List<EsercizioSvolto>? esercizi,
    int? ultimaModifica,
    bool? eliminato,
    bool? sincronizzato,
  }) {
    return RegistroAllenamento(
      id: id,
      titolo: titolo ?? this.titolo,
      schedaOrigineId: schedaOrigineId ?? this.schedaOrigineId,
      dataInizio: dataInizio ?? this.dataInizio,
      completato: completato ?? this.completato,
      esercizi: esercizi ?? this.esercizi,
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
        'titolo': titolo,
        'schedaOrigineId': schedaOrigineId,
        'dataInizio': dataInizio,
        'completato': completato,
        'esercizi': esercizi.map((e) => e.toJson()).toList(),
      };

  factory RegistroAllenamento.fromJson(Map<String, dynamic> json) =>
      RegistroAllenamento(
        id: json['id'] as String,
        ultimaModifica: json['ultimaModifica'] as int? ?? 0,
        eliminato: json['eliminato'] as bool? ?? false,
        sincronizzato: json['sincronizzato'] as bool? ?? true,
        titolo: json['titolo'] as String,
        schedaOrigineId: json['schedaOrigineId'] as String?,
        dataInizio: json['dataInizio'] as int? ?? 0,
        completato: json['completato'] as bool? ?? false,
        esercizi: (json['esercizi'] as List<dynamic>? ?? [])
            .map((e) => EsercizioSvolto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}