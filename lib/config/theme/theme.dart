import 'package:flutter/material.dart';
import 'package:weather_bnka/config/theme/color_palettes.dart';

/// Builds the app theme from the WMO weather code that Open-Meteo returns in
/// `current_weather.weathercode`.
///
/// Codes are grouped rather than mapped one by one: the palette only needs to
/// know whether it is clear, cloudy, wet or violent outside.
/// See https://open-meteo.com/en/docs for the full table.
class ThemeManager {
  const ThemeManager._();

  static ThemeData themeFor(int? weatherCode) =>
      _themeFrom(paletteFor(weatherCode));

  static ColorPalette paletteFor(int? weatherCode) {
    if (weatherCode == null) return ColorPalettes.sunny;

    // 0 clear · 1-3 mainly clear to overcast
    if (weatherCode <= 1) return ColorPalettes.sunny;
    if (weatherCode <= 3) return ColorPalettes.cloudy;
    // 45-48 fog
    if (weatherCode <= 48) return ColorPalettes.cloudy;
    // 51-67 drizzle and rain · 80-82 showers
    if (weatherCode <= 67) return ColorPalettes.rainy;
    // 71-77 snow
    if (weatherCode <= 77) return ColorPalettes.night;
    if (weatherCode <= 82) return ColorPalettes.rainy;
    // 85-86 snow showers
    if (weatherCode <= 86) return ColorPalettes.night;
    // 95-99 thunderstorm
    return ColorPalettes.stormy;
  }

  static ThemeData _themeFrom(ColorPalette palette) {
    final scheme = ColorScheme(
      brightness: ThemeData.estimateBrightnessForColor(palette.background) ==
              Brightness.dark
          ? Brightness.dark
          : Brightness.light,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.secondary,
      onSecondary: palette.onPrimary,
      error: palette.error,
      onError: Colors.white,
      surface: palette.surface,
      onSurface: palette.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.primary,
        selectedItemColor: palette.onPrimary,
        unselectedItemColor: palette.onPrimary.withValues(alpha: 0.6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
