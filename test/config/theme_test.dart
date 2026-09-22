import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bnka/config/theme/color_palettes.dart';
import 'package:weather_bnka/config/theme/theme.dart';

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
}
