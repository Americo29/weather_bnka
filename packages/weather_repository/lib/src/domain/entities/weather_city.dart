import 'location.dart';
import 'weather.dart';

class WeatherCity {
  final String name;
  Location? location;
  Weather? weather;
  bool isLoading;
  bool isFavorite;

  WeatherCity({
    required this.name,
    this.weather,
    this.location,
    this.isLoading = true,
    this.isFavorite = false,
  });

  WeatherCity copyWith({
    String? name,
    bool? isFavorite,
    Location? location,
    Weather? weather,
  }) {
    return WeatherCity(
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
      location: location ?? this.location,
      weather: weather ?? this.weather,
    );
  }
}
