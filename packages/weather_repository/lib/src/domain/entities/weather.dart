import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final int weatherCode;

  const Weather({
    required this.temperature,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [temperature, weatherCode];
}
