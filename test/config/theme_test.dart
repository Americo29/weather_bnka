import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bnka/config/theme/color_palettes.dart';
import 'package:weather_bnka/config/theme/theme.dart';

/// WCAG 2.1 relative-luminance contrast ratio, from 1 (identical) to 21.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  group('ThemeManager.paletteFor', () {
    // WMO codes, as documented by Open-Meteo.
    const cases = <String, (List<int>, ColorPalette)>{
      'clear sky': ([0, 1], ColorPalettes.sunny),
      'cloudy and fog': ([2, 3, 45, 48], ColorPalettes.cloudy),
      'drizzle and rain': ([51, 61, 65, 67, 80, 82], ColorPalettes.rainy),
      'snow': ([71, 75, 77, 85, 86], ColorPalettes.night),
      'thunderstorm': ([95, 96, 99], ColorPalettes.stormy),
    };

    cases.forEach((name, entry) {
      final (codes, expected) = entry;
      test('maps $name to its palette', () {
        for (final code in codes) {
          expect(ThemeManager.paletteFor(code), same(expected),
              reason: 'code $code');
        }
      });
    });

    test('falls back to the clear palette when there is no reading yet', () {
      expect(ThemeManager.paletteFor(null), same(ColorPalettes.sunny));
    });
  });

  group('ThemeManager.themeFor', () {
    test('carries the palette into the color scheme', () {
      final theme = ThemeManager.themeFor(95); // thunderstorm

      expect(theme.colorScheme.primary, ColorPalettes.stormy.primary);
      expect(theme.scaffoldBackgroundColor, ColorPalettes.stormy.background);
    });

    test('a wet sky and a clear sky do not produce the same theme', () {
      expect(ThemeManager.themeFor(61).colorScheme.primary,
          isNot(ThemeManager.themeFor(0).colorScheme.primary));
    });
  });

  group('contrast', () {
    // Every weather code the API can report, one per palette group.
    const codesPerPalette = [0, 2, 61, 71, 95];
    const minimum = 4.5; // WCAG AA for normal text

    test('the checker itself is right', () {
      expect(contrast(Colors.black, Colors.white), closeTo(21, 0.01));
      expect(contrast(Colors.white, Colors.white), closeTo(1, 0.01));
    });

    test('button and app bar labels are legible on every palette', () {
      for (final code in codesPerPalette) {
        final scheme = ThemeManager.themeFor(code).colorScheme;
        expect(contrast(scheme.onPrimary, scheme.primary),
            greaterThanOrEqualTo(minimum),
            reason: 'code $code');
      }
    });

    test('text buttons are legible on the page behind them', () {
      for (final code in codesPerPalette) {
        final theme = ThemeManager.themeFor(code);
        final foreground = theme.textButtonTheme.style!.foregroundColor!
            .resolve({})!;
        expect(contrast(foreground, theme.scaffoldBackgroundColor),
            greaterThanOrEqualTo(minimum),
            reason: 'code $code');
      }
    });

    test('card text is legible on the card', () {
      for (final code in codesPerPalette) {
        final scheme = ThemeManager.themeFor(code).colorScheme;
        expect(contrast(scheme.onSurface, scheme.surface),
            greaterThanOrEqualTo(minimum),
            reason: 'code $code');
      }
    });
  });
}