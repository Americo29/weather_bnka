import 'package:equatable/equatable.dart';

import 'location.dart';
import 'weather.dart';

/// A city the user follows, together with whatever has been resolved for it.
///
/// `isLoading` is true from the moment the city is followed until its forecast
/// arrives, which is what lets a card render a spinner instead of stale data.
class WeatherCity extends Equatable {
  final String name;
  final Location? location;
  final Weather? weather;
  final bool isLoading;
  final bool isFavorite;

  const WeatherCity({
    required this.name,
    this.weather,
    this.location,
    this.isLoading = true,
    this.isFavorite = false,
  });

  /// Whether the forecast finished loading and can be shown.
  bool get isLoaded => !isLoading && location != null && weather != null;

  WeatherCity copyWith({
    String? name,
    bool? isFavorite,
    bool? isLoading,
    Location? location,
    Weather? weather,
  }) {
    return WeatherCity(
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
      isLoading: isLoading ?? this.isLoading,
      location: location ?? this.location,
      weather: weather ?? this.weather,
    );
  }

  @override
  List<Object?> get props => [name, location, weather, isLoading, isFavorite];
}
