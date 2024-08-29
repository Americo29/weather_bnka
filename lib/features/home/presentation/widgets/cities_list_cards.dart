import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class CitiesListCards extends StatefulWidget {
  final VoidCallback onCityFavorite;

  const CitiesListCards({super.key, required this.onCityFavorite});

  @override
  State<CitiesListCards> createState() => _CitiesListCardsState();
}

class _CitiesListCardsState extends State<CitiesListCards> {
  List<City> cities = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  void _loadCities() {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(LoadCities());
  }

  void _toggleFavorite(String cityName) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(MarkCityAsFavorite(cityName));
    widget.onCityFavorite(); 
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is CitiesLoading) {
        } else if (state is CitiesLoaded) {
          setState(() {
            cities = state.cities;
          });
        } else if (state is CitiesFavoriteUpdated) {
          setState(() {
            cities = state.cities;
          });
        }
      },
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 32),
            child: Text(
              'Selecciona una ciudad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                childAspectRatio: 3, // Adjusts the height of the grid items
              ),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];

                final isFavorite = city.isFavorite;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _toggleFavorite(city.name);
                    },
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              city.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            CircleAvatar(
                              radius: 16, // Adjust the size of the circle
                              backgroundColor: isFavorite
                                  ? Colors.amber[500]
                                  : Colors.grey[300],
                              child: Icon(
                                isFavorite
                                    ? Icons.star
                                    : Icons.star_border_outlined,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
