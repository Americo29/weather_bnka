import '../../domain/entities/city.dart';
import '../../domain/repositories/city_repository.dart';

class CityRepositoryImpl implements CityRepository {
  CityRepositoryImpl();

  @override
  List<City> getCities() {
    return const [
      City(name: "Madrid", isFavorite: false),
      City(name: "Chicago", isFavorite: false),
      City(name: "Berlin", isFavorite: false),
      City(name: "Paris", isFavorite: false),
      City(name: "Bogotá", isFavorite: false),
      City(name: "Tokyo", isFavorite: false),
      City(name: "Barcelona", isFavorite: false),
      City(name: "Buenos Aires", isFavorite: false),
      City(name: "New York", isFavorite: false),
      City(name: "London", isFavorite: false),
      City(name: "Miami", isFavorite: false),
      City(name: "Los Angeles", isFavorite: false),
      City(name: "Medellín", isFavorite: false),
      City(name: "Lagos", isFavorite: false),
      City(name: "Montevideo", isFavorite: false),
      City(name: "Bruselas", isFavorite: false),
      City(name: "Cartagena", isFavorite: false),
      City(name: "Boston", isFavorite: false),
      City(name: "Sydney", isFavorite: false),
      City(name: "Dakar", isFavorite: false),
    ];
  }
}
