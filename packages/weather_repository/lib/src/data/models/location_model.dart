import '../../domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.countryCode,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      countryCode: json['country_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country_code': countryCode,
    };
  }

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, latitude: $latitude, longitude: $longitude, countryCode: $countryCode)';
  }
}
