
import '../../domain/entities/location.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../data_sources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Location> getLocation(String city) async {
    return await remoteDataSource.getLocation(city);
  }

  @override
  Future<Weather> getWeather(double latitude, double longitude) async {
    return await remoteDataSource.getWeather(latitude, longitude);
  }
}
