import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/features/home/presentation/widgets/cities_list_cards.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_app.dart';

class _MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  const catalogue = [
    City(name: 'Madrid'),
    City(name: 'Tokyo', isFavorite: true),
  ];

  late _MockWeatherBloc bloc;

  setUpAll(() => registerFallbackValue(LoadCities()));

  setUp(() {
    bloc = _MockWeatherBloc();
    when(() => bloc.state).thenReturn(WeatherInitial());
  });

  Future<void> pumpGrid(WidgetTester tester, {VoidCallback? onFavorite}) =>
      tester.pumpApp(
        BlocProvider<WeatherBloc>.value(
          value: bloc,
          child: CitiesListCards(onCityFavorite: onFavorite ?? () {}),
        ),
      );

  testWidgets('asks the bloc for the catalogue as soon as it mounts',
      (tester) async {
    await pumpGrid(tester);

    verify(() => bloc.add(any(that: isA<LoadCities>()))).called(1);
    expect(find.text('Selecciona una ciudad'), findsOneWidget);
  });

  testWidgets('lists the catalogue once it arrives', (tester) async {
    whenListen(bloc, Stream.value(const CitiesLoaded(catalogue)),
        initialState: WeatherInitial());
    await pumpGrid(tester);
    await tester.pump();

    expect(find.text('Madrid'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
  });

  testWidgets('marks followed cities with a filled star', (tester) async {
    whenListen(bloc, Stream.value(const CitiesLoaded(catalogue)),
        initialState: WeatherInitial());
    await pumpGrid(tester);
    await tester.pump();

    expect(find.byIcon(Icons.star), findsOneWidget); // Tokyo
    expect(find.byIcon(Icons.star_border_outlined), findsOneWidget); // Madrid
  });

  testWidgets('tapping a city follows it and returns to the detail tab',
      (tester) async {
    var returned = 0;
    whenListen(bloc, Stream.value(const CitiesLoaded(catalogue)),
        initialState: WeatherInitial());
    await pumpGrid(tester, onFavorite: () => returned++);
    await tester.pump();

    await tester.tap(find.text('Madrid'));
    await tester.pump();

    verify(() => bloc.add(const MarkCityAsFavorite('Madrid'))).called(1);
    expect(returned, 1);
  });
}
