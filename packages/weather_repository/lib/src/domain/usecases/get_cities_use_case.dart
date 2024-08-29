import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetCitiesUseCase {
  final CityRepository cityRepository;

  GetCitiesUseCase(this.cityRepository);

  List<City> call() {
    return cityRepository.getCities();
  }
}
