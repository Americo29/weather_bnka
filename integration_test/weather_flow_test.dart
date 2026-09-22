import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_bnka/features/auth/presentation/pages/signup_page.dart';
import 'package:weather_bnka/main.dart' as app;

/// Pumps until [finder] matches. The app leans on real timers and real network
/// calls, which `pumpAndSettle` would either miss or wait out forever.
Future<void> waitFor(WidgetTester tester, Finder finder,
    {int maxPumps = 200}) async {
  for (var i = 0; i < maxPumps; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('never appeared: $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('signup, follow a city, and read its temperature',
      (tester) async {
    app.main();

    // --- Signup, since a fresh install has no user ---
    await waitFor(tester, find.text('Registrarse'));
    await tester.tap(find.text('Registrarse'));
    await waitFor(
        tester, find.widgetWithText(ElevatedButton, 'Registrarse'));

    // The login page stays in the tree below signup, so scope the finders.
    final fields = find.descendant(
      of: find.byType(SignupPage),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(fields.at(0), 'americo');
    await tester.enterText(fields.at(1), 'secret');
    await tester.tap(find.descendant(
      of: find.byType(SignupPage),
      matching: find.widgetWithText(ElevatedButton, 'Registrarse'),
    ));

    await waitFor(tester, find.byType(BottomNavigationBar));
    // Let the route transition finish before touching the nav bar.
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }

    // --- Follow Madrid ---
    await tester.tap(find.byIcon(Icons.location_city).hitTestable());
    await waitFor(tester, find.text('Madrid'));
    // Selecting a city sends the user back to the detail tab on its own.
    await tester.tap(find.text('Madrid'));
    await tester.pump(const Duration(milliseconds: 250));

    // While the forecast is in flight the card spins and the panel claims
    // nothing. The panel renders the city name too, so Madrid appearing once
    // means it is only on its card.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Madrid'), findsOneWidget);
    expect(find.text('Selecciona una ciudad para ver su clima'), findsOneWidget);

    await waitFor(tester, find.textContaining('Temperatura:'));
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Madrid'), findsNWidgets(2),
        reason: 'Madrid is on the panel and on its card');
    expect(find.text('1 ciudad'), findsOneWidget);

    // --- A second city, with Madrid already selected ---
    await tester.tap(find.byIcon(Icons.location_city).hitTestable());
    await waitFor(tester, find.text('Tokyo'));
    await tester.tap(find.text('Tokyo'));
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(CircularProgressIndicator), findsOneWidget,
        reason: 'the new card spins');
    expect(find.text('Tokyo'), findsOneWidget,
        reason: 'Tokyo must not reach the panel while it is still loading');
    expect(find.text('Madrid'), findsNWidgets(2),
        reason: 'Madrid stays selected on the panel');

    await waitFor(tester, find.text('2 ciudades'));

    // Only now does the selection move to the city that finished loading.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Tokyo'), findsNWidgets(2));
  });
}
