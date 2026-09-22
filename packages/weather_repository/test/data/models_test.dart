import 'package:flutter_test/flutter_test.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  group('WeatherModel', () {
    // Shape returned by Open-Meteo under `current_weather`.
    const json = <String, dynamic>{
      'temperature': 21.4,
      'weathercode': 3,
      'windspeed': 9.1,
    };

    test('fromJson maps the API contract onto the domain entity', () {
      final model = WeatherModel.fromJson(json);

      expect(model, isA<Weather>());
      expect(model.temperature, 21.4);
      expect(model.weatherCode, 3);
    });

    test('toJson round-trips back to the API field names', () {
      final model = WeatherModel.fromJson(json);

      expect(model.toJson(), {'temperature': 21.4, 'weathercode': 3});
    });
  });

  group('LocationModel', () {
    // Shape returned by Open-Meteo under `results[0]`.
    const json = <String, dynamic>{
      'id': 3117735,
      'name': 'Madrid',
      'latitude': 40.4165,
      'longitude': -3.70256,
      'country_code': 'ES',
    };

    test('fromJson maps the API contract onto the domain entity', () {
      final model = LocationModel.fromJson(json);

      expect(model, isA<Location>());
      expect(model.id, 3117735);
      expect(model.name, 'Madrid');
      expect(model.latitude, 40.4165);
      expect(model.longitude, -3.70256);
      expect(model.countryCode, 'ES');
    });

    test('toJson uses the snake_case key the API expects', () {
      final model = LocationModel.fromJson(json);

      expect(model.toJson()['country_code'], 'ES');
    });
  });
}
