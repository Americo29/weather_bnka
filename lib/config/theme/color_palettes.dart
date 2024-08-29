import 'package:flutter/material.dart';

class ColorPalettes {
  static const sunny = ColorPalette(
    primary: Color(0xFFFFD700),
    secondary: Color(0xFFFFA500),
    accent: Color(0xFF87CEEB),
    background: Color(0xFFFFFACD),
    onBackground: Color(0xFF000000),
    error: Color(0xFFFF4500),
    onSurface: Color(0xFF000000),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF000000),
  );

  static const rainy = ColorPalette(
    primary: Color(0xFF4682B4),
    secondary: Color(0xFF5F9EA0),
    accent: Color(0xFF708090),
    background: Color(0xFFB0C4DE),
    onBackground: Color(0xFF000000),
    error: Color(0xFFB22222),
    onSurface: Color(0xFFFFFFFF),
    surface: Color(0xFF2F4F4F),
    onPrimary: Color(0xFFFFFFFF),
  );

  static const cloudy = ColorPalette(
    primary: Color(0xFF778899),
    secondary: Color(0xFFA9A9A9),
    accent: Color(0xFFB0C4DE),
    background: Color(0xFFD3D3D3),
    onBackground: Color(0xFF000000),
    error: Color(0xFF8B0000),
    onSurface: Color(0xFF000000),
    surface: Color(0xFFBEBEBE),
    onPrimary: Color(0xFFFFFFFF),
  );

  static const stormy = ColorPalette(
    primary: Color(0xFF4B0082),
    secondary: Color(0xFF2F4F4F),
    accent: Color(0xFF483D8B),
    background: Color(0xFF2C3E50),
    onBackground: Color(0xFFFFFFFF),
    error: Color(0xFF8B0000),
    onSurface: Color(0xFFFFFFFF),
    surface: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
  );

  static const night = ColorPalette(
    primary: Color(0xFF000080),
    secondary: Color(0xFF191970),
    accent: Color(0xFFB0E0E6),
    background: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    error: Color(0xFFFF4500),
    onSurface: Color(0xFFFFFFFF),
    surface: Color(0xFF191970),
    onPrimary: Color(0xFFFFFFFF),
  );
}

class ColorPalette {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color onBackground;
  final Color error;
  final Color onSurface;
  final Color surface;
  final Color onPrimary;

  const ColorPalette({
    required this.accent,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.onSurface,
    required this.surface,
    required this.onPrimary,
    required this.primary,
    required this.secondary,
  });
}
