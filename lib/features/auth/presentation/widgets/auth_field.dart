import 'package:flutter/material.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';

/// The two fields every auth form needs, with identical decoration and rules.
/// Login and signup used to carry their own near-identical copy of this.
class AuthFields extends StatelessWidget {
  static const int minPasswordLength = 4;

  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const AuthFields({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        TextFormField(
          controller: usernameController,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          decoration: _decoration(
            hint: l10n.usernameHint,
            icon: Icons.person_outline_rounded,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.usernameRequired;
            }
            if (value.contains(RegExp(r'[^\w\s]'))) {
              return l10n.usernameInvalidChars;
            }
            return null;
          },
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          autofillHints: const [AutofillHints.password],
          decoration: _decoration(
            hint: l10n.passwordHint,
            icon: Icons.lock_outline,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return l10n.passwordRequired;
            if (value.length < minPasswordLength) {
              return l10n.passwordTooShort(minPasswordLength);
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _decoration({required String hint, required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      hintText: hint,
    );
  }
}
