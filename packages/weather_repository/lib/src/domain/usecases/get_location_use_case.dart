import '../entities/location.dart';
import '../repositories/weather_repository.dart';

class GetLocationUseCase {
  final WeatherRepository weatherRepository;

  GetLocationUseCase(this.weatherRepository);

  Future<Location> call(String city) async {
    return await weatherRepository.getLocation(city);
  }
}
