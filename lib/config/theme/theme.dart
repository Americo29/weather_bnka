import 'package:flutter/material.dart';
import 'package:weather_bnka/config/theme/color_palettes.dart';

class ThemeManager {
  static ThemeData _theme = ThemeData.light();
  static ThemeData get theme => _theme;

  static void setWeatherCondition(int condition) {
    _theme = _getThemeForWeather(condition);
  }

  static ThemeData _getThemeForWeather(int condition) {
    switch (condition) {
      case 1: // Sunny
        return ThemeData(
          primaryColor: ColorPalettes.sunny.primary,
          secondaryHeaderColor: ColorPalettes.sunny.secondary,
          // ... other colors
        );
      case 2: // Rainy
        return ThemeData(
          primaryColor: ColorPalettes.rainy.primary,
          secondaryHeaderColor: ColorPalettes.rainy.secondary,
          // ... other colors
        );
      // ... other cases
      default:
        return ThemeData.light();
    }
  }
}