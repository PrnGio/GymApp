import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemaApp {
  // Colore principale dell'app (verde petrolio sportivo)
  static const Color _coloreSeme = Color.fromARGB(255, 50, 37, 192);

  static ThemeData get temaChiaro {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _coloreSeme,
      brightness: Brightness.light,
    );

    return _costruisciTema(colorScheme);
  }

  static ThemeData get temaScuro {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _coloreSeme,
      brightness: Brightness.dark,
    );

    return _costruisciTema(colorScheme);
  }

static ThemeData _costruisciTema(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,

      // Stile barra superiore
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),

      // Stile uniforme per tutte le Card (esercizi, schede, log)
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),

      // Stile uniforme per i campi di testo (es. inserimento pesi, nomi schede)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      // Stile pulsanti principali
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}