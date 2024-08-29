import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bnka/features/auth/data/data_sources/shared_pref_helper.dart';
import 'package:weather_bnka/features/auth/data/repository/user_repository_impl.dart';
import 'package:weather_bnka/features/auth/domain/repository/user_repository.dart';
import 'package:weather_bnka/features/auth/domain/usecases/login_usecase.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => Dio());

  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<SharedPrefHelper>(
    () => SharedPrefHelper(),
  );

  // Use case
  getIt.registerLazySingleton(() => LoginUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<SharedPrefHelper>()),
  );

  getIt.registerLazySingleton(
      () => GetLocationUseCase(getIt<WeatherRepository>()));
  getIt.registerLazySingleton(
      () => GetWeatherUseCase(getIt<WeatherRepository>()));
  getIt.registerLazySingleton(() => GetCitiesUseCase(getIt<CityRepository>()));

  // Repository
  getIt.registerLazySingleton<WeatherRepository>(
      () => WeatherRepositoryImpl(getIt()));

  getIt
      .registerLazySingleton<CityRepository>(() => CityRepositoryImpl());

  // Data sources
  getIt.registerLazySingleton(() => WeatherRemoteDataSource(getIt()));

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt<LoginUseCase>()),
  );

  getIt.registerFactory<WeatherBloc>(() => WeatherBloc(
        getIt<GetLocationUseCase>(),
        getIt<GetWeatherUseCase>(),
        getIt<GetCitiesUseCase>(),
      ));
}
