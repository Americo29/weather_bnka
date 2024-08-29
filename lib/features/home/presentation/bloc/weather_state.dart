part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherCompleted extends WeatherState {}

class WeatherCityLoading extends WeatherState {
  final String city;

  const WeatherCityLoading(this.city);

  @override
  List<Object> get props => [city];
}

class WeatherCityLoaded extends WeatherState {
  final Location location;
  final Weather? weather;

  const WeatherCityLoaded({required this.location, required this.weather});

  @override
  List<Object> get props => [location, weather as Object? ?? Object()];
}

class WeatherFavCitiesLoaded extends WeatherState {
  final List<WeatherCity> weatherCityList;

  const WeatherFavCitiesLoaded(this.weatherCityList);

  @override
  List<Object> get props => [weatherCityList];
}

final class CitiesLoading extends WeatherState {}

class CitiesLoaded extends WeatherState {
  final List<City> cities;

  const CitiesLoaded(this.cities);

  @override
  List<Object> get props => [cities];
}

class CitiesFavoriteUpdated extends WeatherState {
  final List<City> cities;

  const CitiesFavoriteUpdated(this.cities);

  @override
  List<Object> get props => [cities];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});

  @override
  List<Object> get props => [message];
}
