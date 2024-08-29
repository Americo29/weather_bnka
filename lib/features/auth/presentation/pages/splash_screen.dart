import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_bnka/config/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  double posX = -1.0;
  double posY = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        posX = 1.0;
      });
    });

    Timer(const Duration(milliseconds: 3500), navigateToLogin);
  }

  void navigateToLogin() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Weather ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  TextSpan(
                    text: 'bnka',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            AnimatedContainer(
              duration: const Duration(seconds: 3),
              alignment: Alignment(posX, posY),
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
