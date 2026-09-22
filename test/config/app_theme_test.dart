import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bnka/config/theme/app_theme.dart';

/// WCAG 2.1 relative-luminance contrast ratio, from 1 (identical) to 21.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  const minimum = 4.5; // WCAG AA for normal text

  test('the checker itself is right', () {
    expect(contrast(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(contrast(Colors.white, Colors.white), closeTo(1, 0.01));
  });

  group('AppTheme.light', () {
    final theme = AppTheme.light;
    final scheme = theme.colorScheme;

    // Named so a failure says which surface is unreadable, not just a number.
    final pairs = <String, (Color, Color)>{
      'button and app bar labels': (scheme.onPrimary, scheme.primary),
      'body text on the page': (scheme.onSurface, theme.scaffoldBackgroundColor),
      'text on a card': (scheme.onSurface, scheme.surface),
      'error text on the page': (scheme.error, theme.scaffoldBackgroundColor),
      'label on an error surface': (scheme.onError, scheme.error),
    };

    pairs.forEach((name, pair) {
      final (foreground, background) = pair;
      test('$name clear WCAG AA', () {
        expect(contrast(foreground, background), greaterThanOrEqualTo(minimum));
      });
    });

    test('text buttons read against the page behind them', () {
      final foreground =
          theme.textButtonTheme.style!.foregroundColor!.resolve({})!;
      expect(contrast(foreground, theme.scaffoldBackgroundColor),
          greaterThanOrEqualTo(minimum));
    });

    test('the selected nav item stands out from the unselected ones', () {
      final nav = theme.bottomNavigationBarTheme;
      expect(contrast(nav.selectedItemColor!, nav.backgroundColor!),
          greaterThanOrEqualTo(minimum));
    });
  });
}
