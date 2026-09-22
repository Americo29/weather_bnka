import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/features/home/presentation/widgets/weather_details.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_app.dart';

class _MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  const madridLocation = Location(
      id: 1, name: 'Madrid', latitude: 1, longitude: 2, countryCode: 'ES');
  const madridWeather = Weather(temperature: 21.4, weatherCode: 0);

  const madridLoaded = WeatherCity(
    name: 'Madrid',
    location: madridLocation,
    weather: madridWeather,
    isLoading: false,
  );
  const tokyoPending = WeatherCity(name: 'Tokyo');

  late _MockWeatherBloc bloc;
  late StreamController<WeatherState> states;

  setUpAll(() => registerFallbackValue(LoadCities()));

  setUp(() {
    bloc = _MockWeatherBloc();
    states = StreamController<WeatherState>.broadcast();
    when(() => bloc.weatherCityList).thenReturn([]);
    whenListen(bloc, states.stream, initialState: WeatherInitial());
  });

  tearDown(() => states.close());

  Future<void> pumpDetails(WidgetTester tester) => tester.pumpApp(
        BlocProvider<WeatherBloc>.value(
          value: bloc,
          child: const WeatherDetails(),
        ),
      );

  /// Pushes [state] and lets the widget settle on it.
  Future<void> emit(WidgetTester tester, WeatherState state) async {
    states.add(state);
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows a spinner while a city is still loading', (tester) async {
    await pumpDetails(tester);

    await emit(tester, const WeatherFavCitiesLoaded([tokyoPending]));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget, reason: 'only on its card');
    expect(find.text('Selecciona una ciudad para ver su clima'), findsOneWidget);
    expect(find.textContaining('Temperatura:'), findsNothing);
  });

  testWidgets('puts a city on the panel only once it finished loading',
      (tester) async {
    await pumpDetails(tester);

    await emit(tester, const WeatherFavCitiesLoaded([madridLoaded]));
    expect(find.text('Selecciona una ciudad para ver su clima'), findsOneWidget,
        reason: 'loaded, but the user has not been switched to it yet');

    await emit(
      tester,
      const WeatherCityLoaded(
          city: 'Madrid', location: madridLocation, weather: madridWeather),
    );

    // Madrid is now on the panel as well as on its card.
    expect(find.text('Madrid'), findsNWidgets(2));
    expect(find.text('Temperatura: 21.4 °C'), findsNWidgets(2));
  });

  testWidgets('keeps the previous city on the panel while a new one loads',
      (tester) async {
    await pumpDetails(tester);
    await emit(tester, const WeatherFavCitiesLoaded([madridLoaded]));
    await emit(
      tester,
      const WeatherCityLoaded(
          city: 'Madrid', location: madridLocation, weather: madridWeather),
    );

    await emit(
        tester, const WeatherFavCitiesLoaded([madridLoaded, tokyoPending]));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget,
        reason: 'Tokyo must not reach the panel while it is loading');
    expect(find.text('Madrid'), findsNWidgets(2),
        reason: 'Madrid stays selected');
  });

  testWidgets('keeps the previous selection when a load fails',
      (tester) async {
    await pumpDetails(tester);
    await emit(tester, const WeatherFavCitiesLoaded([madridLoaded]));
    await emit(
      tester,
      const WeatherCityLoaded(
          city: 'Madrid', location: madridLocation, weather: madridWeather),
    );

    // The bloc withdraws the failed placeholder and reports the error.
    await emit(tester, const WeatherFavCitiesLoaded([madridLoaded]));
    await emit(tester, const WeatherError());

    expect(find.text('Madrid'), findsNWidgets(2),
        reason: 'the panel still shows the city that did load');
    expect(find.byType(CircularProgressIndicator), findsNothing,
        reason: 'no card is left spinning forever');
    expect(find.text('No se pudo obtener la información del clima'),
        findsOneWidget);
  });

  testWidgets('summarises only the cities that finished loading',
      (tester) async {
    await pumpDetails(tester);

    await emit(
        tester, const WeatherFavCitiesLoaded([madridLoaded, tokyoPending]));

    // Tokyo has no temperature yet, so it cannot count towards the summary.
    expect(find.text('1 ciudad'), findsOneWidget);
    expect(find.textContaining('Más cálida: Madrid'), findsOneWidget);
  });
}
