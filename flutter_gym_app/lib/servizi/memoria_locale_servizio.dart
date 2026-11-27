// Questo file si occupa esclusivamente di leggere e scrivere gli elenchi in formato JSON dentro SharedPreferences
//così i dati restano salvati sul telefono o sul browser anche offline.
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelli/esercizio.dart';
import '../modelli/scheda_allenamento.dart';
import '../modelli/registro_allenamento.dart';

class MemoriaLocaleServizio {
  static const String _chiaveEsercizi = 'gymapp_esercizi_v1';
  static const String _chiaveSchede = 'gymapp_schede_v1';
  static const String _chiaveRegistri = 'gymapp_registri_v1';
  static const String _chiaveCodiceUtente = 'gymapp_codice_utente_v1';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _istanza async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // --- ESERCIZI ---
  Future<List<Esercizio>> caricaEsercizi() async {
    final prefs = await _istanza;
    final raw = prefs.getString(_chiaveEsercizi);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> listaJson = jsonDecode(raw) as List<dynamic>;
    return listaJson
        .map((e) => Esercizio.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvaEsercizi(List<Esercizio> esercizi) async {
    final prefs = await _istanza;
    final jsonString = jsonEncode(esercizi.map((e) => e.toJson()).toList());
    await prefs.setString(_chiaveEsercizi, jsonString);
  }

  // --- SCHEDE ALLENAMENTO ---
  Future<List<SchedaAllenamento>> caricaSchede() async {
    final prefs = await _istanza;
    final raw = prefs.getString(_chiaveSchede);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> listaJson = jsonDecode(raw) as List<dynamic>;
    return listaJson
        .map((e) => SchedaAllenamento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvaSchede(List<SchedaAllenamento> schede) async {
    final prefs = await _istanza;
    final jsonString = jsonEncode(schede.map((s) => s.toJson()).toList());
    await prefs.setString(_chiaveSchede, jsonString);
  }

  // --- REGISTRI ALLENAMENTO (LOG) ---
  Future<List<RegistroAllenamento>> caricaRegistri() async {
    final prefs = await _istanza;
    final raw = prefs.getString(_chiaveRegistri);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> listaJson = jsonDecode(raw) as List<dynamic>;
    return listaJson
        .map((e) => RegistroAllenamento.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> salvaRegistri(List<RegistroAllenamento> registri) async {
    final prefs = await _istanza;
    final jsonString = jsonEncode(registri.map((r) => r.toJson()).toList());
    await prefs.setString(_chiaveRegistri, jsonString);
  }

  // --- CODICE ABBINAMENTO (pronto per Fase 3) ---
  Future<String?> caricaCodiceUtente() async {
    final prefs = await _istanza;
    return prefs.getString(_chiaveCodiceUtente);
  }

  Future<void> salvaCodiceUtente(String codice) async {
    final prefs = await _istanza;
    await prefs.setString(_chiaveCodiceUtente, codice);
  }
}