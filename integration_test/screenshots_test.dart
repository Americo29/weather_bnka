import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_bnka/features/auth/presentation/pages/signup_page.dart';
import 'package:weather_bnka/main.dart' as app;

Future<void> waitFor(WidgetTester t, Finder f, {int max = 200}) async {
  for (var i = 0; i < max; i++) {
    await t.pump(const Duration(milliseconds: 100));
    if (f.evaluate().isNotEmpty) return;
  }
  throw TestFailure('never appeared: $f');
}

/// Waits until [text] is on screen [count] times. The detail panel renders the
/// city name too, so two occurrences means "selected", one means "card only".
Future<void> waitForCount(WidgetTester t, String text, int count,
    {int max = 250}) async {
  for (var i = 0; i < max; i++) {
    await t.pump(const Duration(milliseconds: 100));
    if (find.text(text).evaluate().length >= count) return;
  }
  throw TestFailure('"$text" never reached $count occurrences');
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture the product screenshots', (tester) async {
    app.main();

    await waitFor(tester, find.text('Registrarse'));
    await binding.takeScreenshot('01-login');

    await tester.tap(find.text('Registrarse'));
    await waitFor(tester, find.widgetWithText(ElevatedButton, 'Registrarse'));
    final fields = find.descendant(
      of: find.byType(SignupPage),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(fields.at(0), 'demo');
    await tester.enterText(fields.at(1), '1234');
    await binding.takeScreenshot('02-registro');

    await tester.tap(find.descendant(
      of: find.byType(SignupPage),
      matching: find.widgetWithText(ElevatedButton, 'Registrarse'),
    ));
    await waitFor(tester, find.byType(BottomNavigationBar));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }

    await tester.tap(find.byIcon(Icons.location_city).hitTestable());
    await waitFor(tester, find.text('Madrid'));
    await binding.takeScreenshot('03-ciudades');

    // Straight after selecting, while the forecast is still in flight.
    await tester.tap(find.text('Madrid'));
    await tester.pump(const Duration(milliseconds: 300));
    await binding.takeScreenshot('04-cargando');

    await waitForCount(tester, 'Madrid', 2);
    await tester.tap(find.byIcon(Icons.location_city).hitTestable());
    await waitFor(tester, find.text('Tokyo'));
    await tester.tap(find.text('Tokyo'));
    await waitForCount(tester, 'Tokyo', 2);
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
    await binding.takeScreenshot('05-panel');
  });
}
