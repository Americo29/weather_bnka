import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetLocationUseCase getLocationUseCase;
  final GetWeatherUseCase getWeatherUseCase;
  final GetCitiesUseCase getCitiesUseCase;

  List<City> cities = [];
  List<City> favoriteCities = [];
  List<WeatherCity> weatherCityList = [];

  WeatherBloc(
      this.getLocationUseCase, this.getWeatherUseCase, this.getCitiesUseCase)
      : super(WeatherInitial()) {
    on<LoadCities>(_onLoadCities);
    on<MarkCityAsFavorite>(_onMarkCityAsFavorite);
    on<GetWeatherForCity>(_onWeatherDetails);
    on<GetWeatherFavCities>(_onWeatherFavCities);
    on<RemoveWeatherFavCity>(_onRemoveWeatherFavCity);
  }

  Future<void> _onLoadCities(
      LoadCities event, Emitter<WeatherState> emit) async {
    try {
      emit(WeatherLoading());
      cities = getCitiesUseCase();

      // Update the cities list with the favorite status
      final updatedCities = cities.map((city) {
        final isFavorite =
            favoriteCities.any((favCity) => favCity.name == city.name);

        final updatedCity = City(name: city.name, isFavorite: isFavorite);
        return updatedCity;
      }).toList();

      cities = updatedCities;

      emit(CitiesLoaded(cities));
    } catch (error) {
      emit(const WeatherError(message: 'Error al obtener la data'));
    }
  }

  Future<void> _onMarkCityAsFavorite(
      MarkCityAsFavorite event, Emitter<WeatherState> emit) async {
    try {
      emit(CitiesLoading());
      _toggleCity(event.cityName, emit);
    } catch (error) {
      emit(const WeatherError(message: 'Error al obtener la data'));
    }
  }

  Future<void> _onWeatherDetails(
      GetWeatherForCity event, Emitter<WeatherState> emit) async {
    final city = event.city;

    // Publish a placeholder before awaiting, so the card can show a spinner
    // even if the widget mounts after the request already started.
    weatherCityList.add(WeatherCity(name: city, isFavorite: true));
    emit(WeatherCityLoading(city));
    emit(WeatherFavCitiesLoaded(List.of(weatherCityList)));

    try {
      final location = await getLocationUseCase.call(city);
      final weather =
          await getWeatherUseCase.call(location.latitude, location.longitude);

      // Keep the catalogue name as the identity: the API may answer with a
      // different one (it returns "Brussels" for "Bruselas").
      final index = weatherCityList.indexWhere((c) => c.name == city);
      if (index != -1) {
        weatherCityList[index] = weatherCityList[index].copyWith(
          location: location,
          weather: weather,
          isLoading: false,
        );
      }

      emit(WeatherFavCitiesLoaded(List.of(weatherCityList)));
      emit(WeatherCityLoaded(location: location, weather: weather, city: city));
    } catch (error) {
      // Drop the placeholder and unmark the city: nothing was loaded, so the
      // previous selection must stay untouched.
      weatherCityList.removeWhere((c) => c.name == city && c.isLoading);
      favoriteCities.removeWhere((c) => c.name == city);
      cities = cities
          .map((c) => c.name == city ? City(name: c.name) : c)
          .toList();

      emit(WeatherFavCitiesLoaded(List.of(weatherCityList)));
      emit(CitiesFavoriteUpdated(cities));
      emit(const WeatherError(message: 'Error al obtener la data'));
    }
  }

  Future<void> _onWeatherFavCities(
      GetWeatherFavCities event, Emitter<WeatherState> emit) async {
    emit(WeatherFavCitiesLoaded(List.of(weatherCityList)));
  }

  Future<void> _onRemoveWeatherFavCity(
      RemoveWeatherFavCity event, Emitter<WeatherState> emit) async {
    _toggleCity(event.city, emit);
    emit(WeatherFavCitiesLoaded(List.of(weatherCityList)));
  }

  /// Flips the favourite flag of [cityName] and starts or discards its forecast.
  void _toggleCity(String cityName, Emitter<WeatherState> emit) {
    final modifiableCities = List<City>.from(cities);
    final index = modifiableCities.indexWhere((city) => city.name == cityName);
    if (index == -1) return;

    final updatedCity = cities[index].toggleFavorite();
    modifiableCities[index] = updatedCity;

    if (updatedCity.isFavorite) {
      if (!favoriteCities.any((city) => city.name == cityName)) {
        favoriteCities.add(updatedCity);
        add(GetWeatherForCity(cityName));
      }
    } else {
      favoriteCities.removeWhere((city) => city.name == cityName);
      weatherCityList.removeWhere((city) => city.name == cityName);
    }

    cities = modifiableCities;
    emit(CitiesFavoriteUpdated(cities));
  }
}
