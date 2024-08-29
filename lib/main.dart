import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_bnka/config/routes/app_routes.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/features/auth/presentation/pages/splash_screen.dart';
import 'package:weather_bnka/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather Bnka',
        home: SplashPage(),
        initialRoute: '/',
        onGenerateRoute: AppRoutes.onGenerateRoutes,
      ),
    );
  }
}
