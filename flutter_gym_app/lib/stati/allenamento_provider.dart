//Questo file è il cervello dell'app: carica gli esercizi predefiniti al primo avvio, salva ogni modifica in locale,
//avvia le sessioni di allenamento e calcola in automatico peso e ripetizioni dell'ultima volta per mostrarli in trasparenza.


import 'package:flutter/foundation.dart';
import '../modelli/esercizio.dart';
import '../modelli/scheda_allenamento.dart';
import '../modelli/registro_allenamento.dart';
import '../servizi/memoria_locale_servizio.dart';

class AllenamentoProvider extends ChangeNotifier {
  final MemoriaLocaleServizio _memoria;

  AllenamentoProvider(this._memoria);

  List<Esercizio> _esercizi = [];
  List<SchedaAllenamento> _schede = [];
  List<RegistroAllenamento> _registri = [];
  bool _inCaricamento = true;

  bool get inCaricamento => _inCaricamento;

  // Liste visibili nella UI (escludono gli elementi con soft-delete)
  List<Esercizio> get esercizi =>
      _esercizi.where((e) => !e.eliminato).toList();

  List<SchedaAllenamento> get schede =>
      _schede.where((s) => !s.eliminato).toList();

  List<RegistroAllenamento> get registri {
    final attivi = _registri.where((r) => !r.eliminato).toList();
    attivi.sort((a, b) => b.dataInizio.compareTo(a.dataInizio));
    return attivi;
  }

  // Liste complete (serviranno nella Fase 3 per sincronizzare anche le eliminazioni)
  List<Esercizio> get tuttiEsercizi => List.unmodifiable(_esercizi);
  List<SchedaAllenamento> get tutteSchede => List.unmodifiable(_schede);
  List<RegistroAllenamento> get tuttiRegistri => List.unmodifiable(_registri);

  /// Carica i dati dalla memoria locale all'avvio dell'app
  Future<void> inizializza() async {
    _inCaricamento = true;
    notifyListeners();

//risolve problemino in memoria modifica da busto a petto
    _esercizi = await _memoria.caricaEsercizi();
    if (_esercizi.isEmpty) {
      _esercizi = List<Esercizio>.from(Esercizio.eserciziPredefiniti);
      await _memoria.salvaEsercizi(_esercizi);
    } else if (_esercizi.any((e) => e.categoria == 'Busto')) {
      _esercizi = _esercizi
          .map((e) => e.categoria == 'Busto' ? e.copyWith(categoria: 'Petto') : e)
          .toList();
      await _memoria.salvaEsercizi(_esercizi);
    }

    _schede = await _memoria.caricaSchede();
    _registri = await _memoria.caricaRegistri();

    _inCaricamento = false;
    notifyListeners();
  }

  // ===========================================================================
  // GESTIONE ESERCIZI
  // ===========================================================================

  Future<void> aggiungiEsercizio({
    required String nome,
    required String categoria,
  }) async {
    final adesso = DateTime.now().millisecondsSinceEpoch;
    final nuovo = Esercizio(
      id: 'es_$adesso',
      ultimaModifica: adesso,
      sincronizzato: false,
      nome: nome.trim(),
      categoria: categoria,
    );

    _esercizi.add(nuovo);
    await _memoria.salvaEsercizi(_esercizi);
    notifyListeners();
  }

  Future<void> eliminaEsercizio(String id) async {
    final indice = _esercizi.indexWhere((e) => e.id == id);
    if (indice == -1) return;

    _esercizi[indice] = _esercizi[indice].copyWith(
      eliminato: true,
      ultimaModifica: DateTime.now().millisecondsSinceEpoch,
      sincronizzato: false,
    );
    await _memoria.salvaEsercizi(_esercizi);
    notifyListeners();
  }

  // ===========================================================================
  // GESTIONE SCHEDE ALLENAMENTO
  // ===========================================================================

  Future<void> salvaScheda({
    String? idEsistente,
    required String nome,
    required List<VoceScheda> voci,
  }) async {
    final adesso = DateTime.now().millisecondsSinceEpoch;

    if (idEsistente == null) {
      final nuova = SchedaAllenamento(
        id: 'sch_$adesso',
        ultimaModifica: adesso,
        sincronizzato: false,
        nome: nome.trim(),
        voci: voci,
      );
      _schede.add(nuova);
    } else {
      final indice = _schede.indexWhere((s) => s.id == idEsistente);
      if (indice != -1) {
        _schede[indice] = _schede[indice].copyWith(
          nome: nome.trim(),
          voci: voci,
          ultimaModifica: adesso,
          sincronizzato: false,
        );
      }
    }

    await _memoria.salvaSchede(_schede);
    notifyListeners();
  }

  Future<void> eliminaScheda(String id) async {
    final indice = _schede.indexWhere((s) => s.id == id);
    if (indice == -1) return;

    _schede[indice] = _schede[indice].copyWith(
      eliminato: true,
      ultimaModifica: DateTime.now().millisecondsSinceEpoch,
      sincronizzato: false,
    );
    await _memoria.salvaSchede(_schede);
    notifyListeners();
  }

  // ===========================================================================
  // GESTIONE REGISTRI ALLENAMENTO (LOG) E STORICO PRECEDENTE
  // ===========================================================================

  Future<RegistroAllenamento> avviaAllenamentoDaScheda(
    SchedaAllenamento scheda,
  ) async {
    final adesso = DateTime.now().millisecondsSinceEpoch;

    final eserciziIniziali = scheda.voci.map((voce) {
      return EsercizioSvolto(
        esercizioId: voce.esercizioId,
        nomeEsercizio: voce.nomeEsercizio,
        note: voce.note,
        serie: List.generate(
          voce.serie,
          (_) => SerieSvolta(
            ripetizioni: voce.ripetizioni,
            peso: voce.pesoTarget,
            completata: false,
          ),
        ),
      );
    }).toList();

    final nuovoRegistro = RegistroAllenamento(
      id: 'log_$adesso',
      ultimaModifica: adesso,
      sincronizzato: false,
      titolo: scheda.nome,
      schedaOrigineId: scheda.id,
      dataInizio: adesso,
      completato: false,
      esercizi: eserciziIniziali,
    );

    _registri.add(nuovoRegistro);
    await _memoria.salvaRegistri(_registri);
    notifyListeners();
    return nuovoRegistro;
  }

  Future<RegistroAllenamento> avviaAllenamentoLibero({
    String titolo = 'Allenamento libero',
  }) async {
    final adesso = DateTime.now().millisecondsSinceEpoch;
    final nuovoRegistro = RegistroAllenamento(
      id: 'log_$adesso',
      ultimaModifica: adesso,
      sincronizzato: false,
      titolo: titolo,
      dataInizio: adesso,
      completato: false,
      esercizi: [],
    );

    _registri.add(nuovoRegistro);
    await _memoria.salvaRegistri(_registri);
    notifyListeners();
    return nuovoRegistro;
  }

  Future<void> aggiornaRegistro(RegistroAllenamento registroAggiornato) async {
    final indice = _registri.indexWhere((r) => r.id == registroAggiornato.id);
    if (indice == -1) return;

    _registri[indice] = registroAggiornato.copyWith(
      ultimaModifica: DateTime.now().millisecondsSinceEpoch,
      sincronizzato: false,
    );
    await _memoria.salvaRegistri(_registri);
    notifyListeners();
  }

  Future<void> eliminaRegistro(String id) async {
    final indice = _registri.indexWhere((r) => r.id == id);
    if (indice == -1) return;

    _registri[indice] = _registri[indice].copyWith(
      eliminato: true,
      ultimaModifica: DateTime.now().millisecondsSinceEpoch,
      sincronizzato: false,
    );
    await _memoria.salvaRegistri(_registri);
    notifyListeners();
  }

  /// Restituisce peso e ripetizioni svolti l'ultima volta per questo esercizio
  /// (usato per mostrare il suggerimento in trasparenza durante l'allenamento)
  SerieSvolta? suggerimentoPrecedente({
    required String esercizioId,
    required int indiceSerie,
    String? escludiRegistroId,
  }) {
    for (final registro in registri) {
      if (registro.id == escludiRegistroId) continue;

      for (final esercizio in registro.esercizi) {
        if (esercizio.esercizioId == esercizioId && esercizio.serie.isNotEmpty) {
          final serieValide = esercizio.serie
              .where((s) => s.completata || s.peso > 0 || s.ripetizioni > 0)
              .toList();
          if (serieValide.isEmpty) continue;

          if (indiceSerie < serieValide.length) {
            return serieValide[indiceSerie];
          }
          return serieValide.last;
        }
      }
    }
    return null;
  }
}