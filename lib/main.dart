import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:weather_bnka/config/routes/app_routes.dart';
import 'package:weather_bnka/config/theme/theme.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/features/auth/presentation/pages/splash_screen.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/injection_container.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        // Hoisted out of HomePage so the theme can follow the weather and so
        // the followed cities survive a tab switch.
        BlocProvider<WeatherBloc>(create: (_) => getIt<WeatherBloc>()),
      ],
      child: BlocBuilder<WeatherBloc, WeatherState>(
        // Only a completed load can repaint the app.
        buildWhen: (_, state) => state is WeatherCityLoaded,
        builder: (context, state) {
          final code = state is WeatherCityLoaded ? state.weather?.weatherCode : null;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather Bnka',
            theme: ThemeManager.themeFor(code),
            locale: const Locale('es'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashPage(),
            initialRoute: '/',
            onGenerateRoute: AppRoutes.onGenerateRoutes,
          );
        },
      ),
    );
  }
}
