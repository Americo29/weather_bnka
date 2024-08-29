import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';

import 'package:weather_bnka/features/auth/presentation/widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide keyboard
        },
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: SignupForm(),
        ),
      ),
    );
  }
}
