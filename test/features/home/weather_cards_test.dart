import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/features/home/presentation/widgets/weather_cards.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_app.dart';

class _MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  const madrid = Location(
      id: 1, name: 'Madrid', latitude: 1, longitude: 2, countryCode: 'ES');

  const loaded = WeatherCity(
    name: 'Madrid',
    location: madrid,
    weather: Weather(temperature: 21.4, weatherCode: 0),
    isLoading: false,
  );
  const pending = WeatherCity(name: 'Tokyo');

  late _MockWeatherBloc bloc;

  setUpAll(() => registerFallbackValue(LoadCities()));

  setUp(() {
    bloc = _MockWeatherBloc();
    when(() => bloc.state).thenReturn(WeatherInitial());
  });

  Future<void> pumpCards(
    WidgetTester tester, {
    required List<WeatherCity> cities,
    String? selected,
    void Function(WeatherCity)? onSelect,
  }) =>
      tester.pumpApp(
        BlocProvider<WeatherBloc>.value(
          value: bloc,
          child: WeatherCardList(
            weatherCityList: cities,
            selectedCity: selected,
            onCardSelected: onSelect ?? (_) {},
          ),
        ),
      );

  testWidgets('a pending city shows a spinner instead of a temperature',
      (tester) async {
    await pumpCards(tester, cities: [pending]);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.textContaining('Temperatura:'), findsNothing);
  });

  testWidgets('a loaded city shows its temperature in Spanish',
      (tester) async {
    await pumpCards(tester, cities: [loaded]);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Temperatura: 21.4 °C'), findsOneWidget);
  });

  testWidgets('tapping a loaded card selects it', (tester) async {
    final taps = <String>[];
    await pumpCards(tester, cities: [loaded], onSelect: (c) => taps.add(c.name));

    await tester.tap(find.text('Madrid'));
    expect(taps, ['Madrid']);
  });

  testWidgets('tapping a pending card selects nothing', (tester) async {
    final taps = <String>[];
    await pumpCards(tester, cities: [pending], onSelect: (c) => taps.add(c.name));

    await tester.tap(find.text('Tokyo'));
    expect(taps, isEmpty, reason: 'there is nothing to show for it yet');
  });

  testWidgets('a pending card cannot be deleted mid-request', (tester) async {
    await pumpCards(tester, cities: [pending]);

    final button = tester.widget<IconButton>(find.byType(IconButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('deleting a loaded card asks the bloc to drop it',
      (tester) async {
    await pumpCards(tester, cities: [loaded]);

    await tester.tap(find.byIcon(Icons.delete_forever));
    verify(() => bloc.add(const RemoveWeatherFavCity('Madrid'))).called(1);
  });

  testWidgets('only the selected card is highlighted', (tester) async {
    await pumpCards(tester, cities: [loaded, pending], selected: 'Madrid');

    final cards = tester.widgetList<Card>(find.byType(Card)).toList();
    expect(cards.first.color, isNotNull, reason: 'Madrid is selected');
    expect(cards.last.color, isNull, reason: 'Tokyo is not');
  });
}
