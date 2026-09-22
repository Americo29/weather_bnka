import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class _MockGetLocationUseCase extends Mock implements GetLocationUseCase {}

class _MockGetWeatherUseCase extends Mock implements GetWeatherUseCase {}

class _MockGetCitiesUseCase extends Mock implements GetCitiesUseCase {}

void main() {
  const catalogue = [City(name: 'Madrid'), City(name: 'Tokyo')];

  final madrid = Location(
    id: 3117735,
    name: 'Madrid',
    latitude: 40.4165,
    longitude: -3.70256,
    countryCode: 'ES',
  );
  final mildWeather = Weather(temperature: 21.4, weatherCode: 3);

  late _MockGetLocationUseCase getLocation;
  late _MockGetWeatherUseCase getWeather;
  late _MockGetCitiesUseCase getCities;

  setUp(() {
    getLocation = _MockGetLocationUseCase();
    getWeather = _MockGetWeatherUseCase();
    getCities = _MockGetCitiesUseCase();
  });

  WeatherBloc buildBloc() => WeatherBloc(getLocation, getWeather, getCities);

  group('WeatherBloc', () {
    test('starts in WeatherInitial', () {
      expect(buildBloc().state, isA<WeatherInitial>());
    });

    group('LoadCities', () {
      blocTest<WeatherBloc, WeatherState>(
        'emits WeatherLoading then the catalogue',
        setUp: () => when(getCities.call).thenReturn(catalogue),
        build: buildBloc,
        act: (bloc) => bloc.add(LoadCities()),
        expect: () => [
          isA<WeatherLoading>(),
          isA<CitiesLoaded>().having((s) => s.cities, 'cities', catalogue),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits WeatherError when the catalogue cannot be read',
        setUp: () => when(getCities.call).thenThrow(Exception('boom')),
        build: buildBloc,
        act: (bloc) => bloc.add(LoadCities()),
        expect: () => [
          isA<WeatherLoading>(),
          isA<WeatherError>()
              .having((s) => s.message, 'message', 'Error al obtener la data'),
        ],
      );
    });

    group('GetWeatherForCity', () {
      blocTest<WeatherBloc, WeatherState>(
        'resolves the city to coordinates before asking for its weather',
        setUp: () {
          when(() => getLocation.call('Madrid')).thenAnswer((_) async => madrid);
          when(() => getWeather.call(any(), any()))
              .thenAnswer((_) async => mildWeather);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const GetWeatherForCity('Madrid')),
        expect: () => [
          isA<WeatherCityLoading>().having((s) => s.city, 'city', 'Madrid'),
          isA<WeatherCityLoaded>()
              .having((s) => s.location.name, 'location', 'Madrid')
              .having((s) => s.weather?.temperature, 'temperature', 21.4),
        ],
        verify: (_) {
          // The coordinates must come from the geocoding call, in order.
          verify(() => getWeather.call(40.4165, -3.70256)).called(1);
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits WeatherError when the city cannot be geocoded',
        setUp: () => when(() => getLocation.call(any()))
            .thenThrow(Exception('Failed to get location')),
        build: buildBloc,
        act: (bloc) => bloc.add(const GetWeatherForCity('Atlantis')),
        expect: () => [
          isA<WeatherCityLoading>(),
          isA<WeatherError>(),
        ],
      );
    });

    group('MarkCityAsFavorite', () {
      blocTest<WeatherBloc, WeatherState>(
        'marks the city and chains a weather lookup for it',
        setUp: () {
          when(getCities.call).thenReturn(catalogue);
          when(() => getLocation.call('Madrid')).thenAnswer((_) async => madrid);
          when(() => getWeather.call(any(), any()))
              .thenAnswer((_) async => mildWeather);
        },
        build: buildBloc,
        act: (bloc) => bloc
          ..add(LoadCities())
          ..add(const MarkCityAsFavorite('Madrid')),
        expect: () => [
          isA<WeatherLoading>(),
          isA<CitiesLoaded>(),
          isA<CitiesLoading>(),
          isA<CitiesFavoriteUpdated>().having(
            (s) => s.cities.firstWhere((c) => c.name == 'Madrid').isFavorite,
            'Madrid is favorite',
            isTrue,
          ),
          // MarkCityAsFavorite dispatches GetWeatherForCity internally.
          isA<WeatherCityLoading>(),
          isA<WeatherCityLoaded>(),
        ],
        verify: (bloc) {
          expect(bloc.favoriteCities.map((c) => c.name), ['Madrid']);
          expect(bloc.weatherCityList.map((c) => c.name), ['Madrid']);
        },
      );

      blocTest<WeatherBloc, WeatherState>(
        'leaves untouched cities alone',
        setUp: () {
          when(getCities.call).thenReturn(catalogue);
          when(() => getLocation.call('Madrid')).thenAnswer((_) async => madrid);
          when(() => getWeather.call(any(), any()))
              .thenAnswer((_) async => mildWeather);
        },
        build: buildBloc,
        act: (bloc) => bloc
          ..add(LoadCities())
          ..add(const MarkCityAsFavorite('Madrid')),
        verify: (bloc) {
          final tokyo = bloc.cities.firstWhere((c) => c.name == 'Tokyo');
          expect(tokyo.isFavorite, isFalse);
        },
      );
    });

    blocTest<WeatherBloc, WeatherState>(
      'GetWeatherFavCities replays the cities already fetched',
      build: buildBloc,
      act: (bloc) => bloc.add(GetWeatherFavCities()),
      expect: () => [
        isA<WeatherFavCitiesLoaded>()
            .having((s) => s.weatherCityList, 'list', isEmpty),
      ],
    );
  });
}
