import 'package:flutter/material.dart';

import 'package:weather_bnka/features/auth/presentation/pages/login_page.dart';
import 'package:weather_bnka/features/auth/presentation/pages/signup_page.dart';
import 'package:weather_bnka/features/auth/presentation/pages/splash_screen.dart';
import 'package:weather_bnka/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String splash = '/splash';
  static const String home = '/home';

  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _materialRoute(const SplashPage());
      case login:
        return _materialRoute(const LoginPage());
      case signup:
        return _materialRoute(const SignupPage());
      case home:
        return _materialRoute(const HomePage());
      default:
        return _materialRoute(const LoginPage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
