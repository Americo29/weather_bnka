import 'package:flutter/material.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';

/// Turns an [AuthFailureReason] into localized copy. The bloc reports why the
/// attempt failed; deciding what to say about it belongs here.
class AuthFailureText extends StatelessWidget {
  final AuthFailureReason? reason;

  const AuthFailureText({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    final reason = this.reason;
    if (reason == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final message = switch (reason) {
      AuthFailureReason.userNotFound => l10n.authUserNotFound,
      AuthFailureReason.wrongCredentials => l10n.authWrongCredentials,
      AuthFailureReason.unknownUser => l10n.authUnknownUser,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
