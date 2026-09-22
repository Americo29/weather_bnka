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

  /// Black or white, whichever reads better on [background].
  ///
  /// The palettes declare their own `onPrimary`, but some of those pairings do
  /// not clear WCAG AA: white on `rainy` scores 4.11 and on `cloudy` 3.64. The
  /// threshold is where contrast against black and against white is equal.
  @visibleForTesting
  static Color readableOn(Color background) =>
      background.computeLuminance() > 0.179 ? Colors.black : Colors.white;

  static ThemeData _themeFrom(ColorPalette palette) {
    final onPrimary = readableOn(palette.primary);
    // A text button sits on the page, not on a filled surface, so it has to
    // contrast with the background. Using `primary` fails in every palette
    // (1.18 to 2.43) -- most visibly gold on cream at 1.32.
    final onBackground = readableOn(palette.background);

    final scheme = ColorScheme(
      brightness: ThemeData.estimateBrightnessForColor(palette.background) ==
              Brightness.dark
          ? Brightness.dark
          : Brightness.light,
      primary: palette.primary,
      onPrimary: onPrimary,
      secondary: palette.secondary,
      onSecondary: readableOn(palette.secondary),
      error: palette.error,
      onError: readableOn(palette.error),
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
        foregroundColor: onPrimary,
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
        selectedItemColor: onPrimary,
        unselectedItemColor: onPrimary.withValues(alpha: 0.7),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: onBackground),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
