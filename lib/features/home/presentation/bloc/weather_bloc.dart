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
      final cityName = event.cityName;
      final List<City> modifiableCities = List.from(cities);

      final index =
          modifiableCities.indexWhere((city) => city.name == cityName);

      if (index != -1) {
        final updatedCity = cities[index].toggleFavorite();

        modifiableCities[index] = updatedCity;

        if (updatedCity.isFavorite) {
          if (!favoriteCities.any((city) => city.name == cityName)) {
            add(GetWeatherForCity(cityName));
            favoriteCities.add(updatedCity);
          }
        } else {
          favoriteCities.removeWhere((city) => city.name == cityName);
          weatherCityList.removeWhere((city) => city.name == cityName);
        }

        cities = modifiableCities;

        emit(CitiesFavoriteUpdated(cities));
      }
    } catch (error) {
      emit(const WeatherError(message: 'FError al obtener la data'));
    }
  }

  Future<void> _onWeatherDetails(
      GetWeatherForCity event, Emitter<WeatherState> emit) async {
    try {
      final city = event.city;

      emit(WeatherCityLoading(city));

      final location = await getLocationUseCase.call(city);

      final weather =
          await getWeatherUseCase.call(location.latitude, location.longitude);

      weatherCityList.add(WeatherCity(
          name: location.name, location: location, weather: weather));

      emit(WeatherCityLoaded(location: location, weather: weather));
    } catch (error) {
      emit(
        const WeatherError(message: 'Error al obtener la data'),
      );
    }
  }

  Future<void> _onWeatherFavCities(
      GetWeatherFavCities event, Emitter<WeatherState> emit) async {
    emit(WeatherFavCitiesLoaded(weatherCityList));
  }

  Future<void> _onRemoveWeatherFavCity(
      RemoveWeatherFavCity event, Emitter<WeatherState> emit) async {
    final cityName = event.city;
    final List<City> modifiableCities = List.from(cities);

    final index = modifiableCities.indexWhere((city) => city.name == cityName);

    if (index != -1) {
      final updatedCity = cities[index].toggleFavorite();

      modifiableCities[index] = updatedCity;

      if (updatedCity.isFavorite) {
        if (!favoriteCities.any((city) => city.name == cityName)) {
          add(GetWeatherForCity(cityName));
          favoriteCities.add(updatedCity);
        }
      } else {
        favoriteCities.removeWhere((city) => city.name == cityName);
        weatherCityList.removeWhere((city) => city.name == cityName);
      }

      cities = modifiableCities;

      emit(CitiesFavoriteUpdated(cities));
      emit(WeatherFavCitiesLoaded(weatherCityList));
    }
  }
}
