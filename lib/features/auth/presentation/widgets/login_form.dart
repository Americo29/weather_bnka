import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/config/routes/app_routes.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/features/auth/presentation/widgets/action_button.dart';
import 'package:weather_bnka/features/auth/presentation/widgets/auth_field.dart';
import 'package:weather_bnka/features/auth/presentation/widgets/auth_failure_text.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthFailureReason? _failure;

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _failure = null);
    context.read<AuthBloc>().add(
          LoginEvent(_usernameController.text, _passwordController.text),
        );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthFailure) {
          setState(() => _failure = state.reason);
        } else if (state is AuthInitial) {
          setState(() => _failure = null);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AuthFields(
              usernameController: _usernameController,
              passwordController: _passwordController,
            ),
            AuthFailureText(reason: _failure),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(l10n.forgotPassword),
              ),
            ),
            const SizedBox(height: 20.0),
            ActionButton(text: l10n.loginAction, onPressed: _login),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.signup),
              child: Text(l10n.signupAction),
            ),
          ],
        ),
      ),
    );
  }
}
