import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String name;
  final bool isFavorite;

  const City({required this.name, this.isFavorite = false});

  City toggleFavorite() {
    return City(name: name, isFavorite: !isFavorite);
  }

  @override
  List<Object?> get props => [name, isFavorite];
}
