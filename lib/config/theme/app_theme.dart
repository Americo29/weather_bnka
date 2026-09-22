import 'package:flutter/material.dart';

/// The app's single theme.
///
/// An earlier version derived the palette from the forecast, but the WMO code
/// describes the sky rather than the temperature, and in practice almost every
/// city reports 0-3 (clear to overcast) -- so the app was amber nearly always,
/// including while showing 11 °C. Chrome that changes under the user without
/// telling them anything is worse than chrome that stays put.
///
/// Every colour pair below clears WCAG AA (4.5:1); `app_theme_test` measures
/// them rather than trusting this comment.
class AppTheme {
  const AppTheme._();

  static const _primary = Color(0xFF12486B);
  static const _secondary = Color(0xFF2E7DA1);
  static const _background = Color(0xFFF4F7FA);
  static const _surface = Color(0xFFFFFFFF);
  static const _onSurface = Color(0xFF11202B);
  static const _error = Color(0xFFB3261E);

  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      error: _error,
      onError: Colors.white,
      surface: _surface,
      onSurface: _onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _background,
      fontFamily: 'Manrope',
      appBarTheme: const AppBarTheme(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFFB8CBD8),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
