import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository weatherRepository;

  GetWeatherUseCase(this.weatherRepository);

  Future<Weather> call(double latitude, double longitude) async {
    return await weatherRepository.getWeather(latitude, longitude);
  }
}
