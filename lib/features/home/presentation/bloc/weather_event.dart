part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForCity extends WeatherEvent {
  final String city;

  const GetWeatherForCity(this.city);

  @override
  List<Object> get props => [city];
}

class GetWeatherFavCities extends WeatherEvent {}

class RemoveWeatherFavCity extends WeatherEvent {
  final String city;

  const RemoveWeatherFavCity(this.city);

  @override
  List<Object> get props => [city];
}

class GetFavoriteCities extends WeatherEvent {}

class LoadCities extends WeatherEvent {}

class MarkCityAsFavorite extends WeatherEvent {
  final String cityName;
  const MarkCityAsFavorite(this.cityName);

  @override
  List<Object> get props => [cityName];
}
