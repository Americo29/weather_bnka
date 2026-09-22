import 'package:flutter_test/flutter_test.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  group('CityRepositoryImpl', () {
    late CityRepositoryImpl repository;

    setUp(() => repository = CityRepositoryImpl());

    test('exposes the full static catalogue', () {
      expect(repository.getCities(), hasLength(20));
    });

    test('every city starts unmarked', () {
      expect(
        repository.getCities().every((city) => !city.isFavorite),
        isTrue,
      );
    });

    test('city names are unique', () {
      final names = repository.getCities().map((city) => city.name).toList();

      expect(names.toSet(), hasLength(names.length));
    });
  });
}
