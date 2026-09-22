import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_bnka/features/auth/presentation/widgets/auth_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  late TextEditingController username;
  late TextEditingController password;
  late GlobalKey<FormState> formKey;

  setUp(() {
    username = TextEditingController();
    password = TextEditingController();
    formKey = GlobalKey<FormState>();
  });

  tearDown(() {
    username.dispose();
    password.dispose();
  });

  Future<void> pumpFields(WidgetTester tester) => tester.pumpApp(
        Form(
          key: formKey,
          child: AuthFields(
            usernameController: username,
            passwordController: password,
          ),
        ),
      );

  Future<bool> validate(WidgetTester tester) async {
    final result = formKey.currentState!.validate();
    await tester.pump();
    return result;
  }

  testWidgets('renders its labels in Spanish', (tester) async {
    await pumpFields(tester);

    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
  });

  testWidgets('rejects an empty form and says why', (tester) async {
    await pumpFields(tester);

    expect(await validate(tester), isFalse);
    expect(find.text('Por favor ingrese su nombre de usuario'), findsOneWidget);
    expect(find.text('Por favor ingrese su contraseña'), findsOneWidget);
  });

  testWidgets('rejects a username with special characters', (tester) async {
    await pumpFields(tester);
    username.text = 'americo!';
    password.text = 'secret';

    expect(await validate(tester), isFalse);
    expect(find.text('El nombre no puede contener caracteres especiales'),
        findsOneWidget);
  });

  testWidgets('rejects a password below the minimum length', (tester) async {
    await pumpFields(tester);
    username.text = 'americo';
    password.text = 'abc';

    expect(await validate(tester), isFalse);
    expect(find.text('La contraseña debe tener al menos 4 caracteres'),
        findsOneWidget);
  });

  testWidgets('accepts a well formed pair', (tester) async {
    await pumpFields(tester);
    username.text = 'americo';
    password.text = 'secret';

    expect(await validate(tester), isTrue);
  });

  testWidgets('hides what is typed in the password field', (tester) async {
    await pumpFields(tester);

    final field = tester.widget<TextField>(
      find.descendant(
        of: find.byType(TextFormField).last,
        matching: find.byType(TextField),
      ),
    );
    expect(field.obscureText, isTrue);
  });
}
