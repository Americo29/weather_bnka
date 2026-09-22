import 'package:flutter_test/flutter_test.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  group('City', () {
    test('defaults to not favorite', () {
      expect(const City(name: 'Madrid').isFavorite, isFalse);
    });

    test('toggleFavorite returns a new instance and leaves the original intact', () {
      const original = City(name: 'Madrid');

      final toggled = original.toggleFavorite();

      expect(toggled.isFavorite, isTrue);
      expect(toggled.name, 'Madrid');
      expect(original.isFavorite, isFalse, reason: 'the entity must stay immutable');
    });

    test('toggling twice returns to the initial value', () {
      const original = City(name: 'Madrid');

      expect(original.toggleFavorite().toggleFavorite(), original);
    });

    test('compares by value, not by identity', () {
      expect(const City(name: 'Madrid'), const City(name: 'Madrid'));
      expect(
        const City(name: 'Madrid'),
        isNot(const City(name: 'Madrid', isFavorite: true)),
      );
    });
  });
}
