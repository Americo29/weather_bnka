import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/config/routes/app_routes.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/features/auth/presentation/widgets/action_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String? _errorMessage;

  late String _username;
  late String _password;

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });

      final authBloc = BlocProvider.of<AuthBloc>(context);
      authBloc.add(LoginEvent(_username, _password));
    }
  }

  InputDecoration _decoration(int option) {
    return InputDecoration(
      focusColor: Colors.white,
      prefixIcon: Icon(
        option == 1 ? Icons.person_outline_rounded : Icons.lock_outline,
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 1.0),
        borderRadius: BorderRadius.circular(40.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(50.0),
      ),
      fillColor: Colors.grey,
      hintText: option == 1 ? "Username" : 'Password',
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.home,
          );
        } else if (state is AuthFailure) {
          setState(() {
            _errorMessage = state.error;
          });
        } else if (state is AuthInitial) {
          setState(() {
            _errorMessage = null;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                TextFormField(
                  focusNode: _usernameFocusNode,
                  controller: _usernameController,
                  decoration: _decoration(1),
                  onChanged: (value) => _username = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre de usuario';
                    }
                    if (value.contains(RegExp(r'[^\w\s]'))) {
                      return 'El nombre no puede contener caracteres especiales';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  decoration: _decoration(0),
                  obscureText: true,
                  onChanged: (value) => _password = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    } else if (value.length < 4) {
                      return 'La contraseña debe tener al menos 4 caracteres.';
                    }
                    return null;
                  },
                ),
              ],
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle "Forgot Password"
                },
                child: const Text(
                  '¿Has olvidado tu contraseña?',
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.lightBlue),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: screenWidth * 0.85,
              child: ActionButton(
                text: 'Login',
                onPressed: _login,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signup);
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.lightBlue, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
