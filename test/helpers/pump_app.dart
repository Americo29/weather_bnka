import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';

/// Wraps [child] in the localization scaffolding every widget in this app
/// expects, so tests read the same Spanish copy the user sees.
///
/// Callers that need a bloc pass it in already wrapped, e.g.
/// `pumpApp(BlocProvider.value(value: bloc, child: widget))`.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget child) {
    return pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      ),
    );
  }
}
