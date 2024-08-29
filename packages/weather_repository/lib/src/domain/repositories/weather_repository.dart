import '../entities/location.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Location> getLocation(String city);
  Future<Weather> getWeather(double latitude, double longitude);
}
