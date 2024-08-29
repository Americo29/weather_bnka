import 'package:dio/dio.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<LocationModel> getLocation(String city) async {
    try {
      final response = await dio.get(
          'https://geocoding-api.open-meteo.com/v1/search',
          queryParameters: {
            'name': city,
            'count': 1,
          });

      final data = response.data['results'][0];
      return LocationModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  Future<WeatherModel> getWeather(double latitude, double longitude) async {
    try {
      final response = await dio
          .get('https://api.open-meteo.com/v1/forecast', queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current_weather': true,
      });

      final data = response.data['current_weather'];

      return WeatherModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to get weather: $e');
    }
  }
}
