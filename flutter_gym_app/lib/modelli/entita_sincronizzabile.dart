abstract class EntitaSincronizzabile {
  final String id;
  final int ultimaModifica; // Timestamp in millisecondi
  final bool eliminato;     // Soft-delete per sincronizzare le cancellazioni
  final bool sincronizzato; // Flag solo locale (false = da inviare a Firebase)

  const EntitaSincronizzabile({
    required this.id,
    required this.ultimaModifica,
    this.eliminato = false,
    this.sincronizzato = false,
  });
}