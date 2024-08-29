// weather_model.dart (Data Layer)
import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel({
    required super.temperature,
    required super.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temperature'],
      weatherCode: json['weathercode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'weathercode': weatherCode,
    };
  }

  @override
  String toString() {
    return 'WeatherModel(temperature: $temperature, weathercode: $weatherCode)';
  }
}
