import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

class _MockWeatherRepository extends Mock implements WeatherRepository {}

class _MockCityRepository extends Mock implements CityRepository {}

void main() {
  group('GetLocationUseCase', () {
    late _MockWeatherRepository repository;
    late GetLocationUseCase useCase;

    setUp(() {
      repository = _MockWeatherRepository();
      useCase = GetLocationUseCase(repository);
    });

    test('delegates to the repository and returns its location', () async {
      const location = Location(
        id: 1,
        name: 'Madrid',
        latitude: 40.4165,
        longitude: -3.70256,
        countryCode: 'ES',
      );
      when(() => repository.getLocation('Madrid'))
          .thenAnswer((_) async => location);

      final result = await useCase('Madrid');

      expect(result, same(location));
      verify(() => repository.getLocation('Madrid')).called(1);
    });

    test('lets a repository failure surface to the caller', () {
      when(() => repository.getLocation(any()))
          .thenThrow(Exception('Failed to get location'));

      expect(() => useCase('Atlantis'), throwsException);
    });
  });

  group('GetWeatherUseCase', () {
    late _MockWeatherRepository repository;
    late GetWeatherUseCase useCase;

    setUp(() {
      repository = _MockWeatherRepository();
      useCase = GetWeatherUseCase(repository);
    });

    test('forwards the coordinates it was given, in order', () async {
      const weather = Weather(temperature: 21.4, weatherCode: 3);
      when(() => repository.getWeather(any(), any()))
          .thenAnswer((_) async => weather);

      final result = await useCase(40.4165, -3.70256);

      expect(result, same(weather));
      verify(() => repository.getWeather(40.4165, -3.70256)).called(1);
    });
  });

  group('GetCitiesUseCase', () {
    test('returns the catalogue exposed by the repository', () {
      final repository = _MockCityRepository();
      const cities = [City(name: 'Madrid'), City(name: 'Tokyo')];
      when(repository.getCities).thenReturn(cities);

      expect(GetCitiesUseCase(repository)(), cities);
    });
  });
}
