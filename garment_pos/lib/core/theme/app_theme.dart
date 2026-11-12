import 'package:flutter/material.dart';

/// Material 3 theme for Garment POS.
///
/// A single seed colour drives light and dark schemes so the whole app
/// (mobile, tablet and Windows) looks consistent. The bundled
/// Noto Sans Bengali font keeps Bengali text correct on every device,
/// including Windows machines without a Bengali font installed.
class AppTheme {
  const AppTheme._();

  /// Deep teal-green seed: reads as a professional garment-trade brand
  /// colour and keeps enough contrast for price/stock figures.
  static const Color seedColor = Color(0xFF0B6E4F);

  static const String fontFamily = 'NotoSansBengali';

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      // Fall back to platform fonts for any glyph the bundled font
      // does not contain.
      fontFamilyFallback: const ['Noto Sans Bengali', 'Roboto', 'sans-serif'],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
