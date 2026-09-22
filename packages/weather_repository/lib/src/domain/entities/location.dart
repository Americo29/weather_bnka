import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String countryCode;

  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.countryCode,
  });

  @override
  List<Object?> get props => [id, name, latitude, longitude, countryCode];
}
