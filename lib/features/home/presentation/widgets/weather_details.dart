import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/core/util/utils.dart';

import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/features/home/presentation/widgets/weather_cards.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({super.key});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  int? _selectedIndex;

  final List<Location?> _locations = [];
  final List<Weather?> _weathers = [];

  List<WeatherCity> weatherCityList = [];
  List<City> favoriteCities = [];

  late WeatherCity ciudadCaliente = WeatherCity(name: '');
  late WeatherCity ciudadFria = WeatherCity(name: '');

  @override
  void initState() {
    super.initState();

    _loadWeatherFavoriteCities();
  }

  void _loadWeatherFavoriteCities() {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(GetWeatherFavCities());
  }

  void _onCardSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherCityLoading) {
          setState(() {
            weatherCityList.add(
              WeatherCity(name: state.city, isLoading: true),
            );
          });
        } else if (state is WeatherCityLoaded) {
          setState(() {
            _locations.clear();
            _weathers.clear();
            _locations.addAll(weatherCityList.map((we) => we.location));
            _weathers.addAll(weatherCityList.map((we) => we.weather));

            final index = weatherCityList
                .indexWhere((city) => city.name == state.location.name);
            if (index != -1) {
              weatherCityList[index]
                ..location = state.location
                ..weather = state.weather
                ..isLoading = false;
              _selectedIndex = index;

              if (weatherCityList.isNotEmpty) {
                ciudadCaliente = weatherCityList.reduce((a, b) =>
                    a.weather!.temperature > b.weather!.temperature ? a : b);
                ciudadFria = weatherCityList.reduce((a, b) =>
                    a.weather!.temperature < b.weather!.temperature ? a : b);
              }
            }
          });
        } else if (state is CitiesFavoriteUpdated) {
          // _getWeatherCities(state.cities);
        } else if (state is WeatherFavCitiesLoaded) {
          setState(() {
            setState(() {
              weatherCityList = state.weatherCityList;

              if (weatherCityList.isNotEmpty) {
                ciudadCaliente = weatherCityList.reduce((a, b) =>
                    a.weather!.temperature > b.weather!.temperature ? a : b);
                ciudadFria = weatherCityList.reduce((a, b) =>
                    a.weather!.temperature < b.weather!.temperature ? a : b);
              }

              _locations.clear();
              _weathers.clear();
              _locations.addAll(weatherCityList.map((we) => we.location));
              _weathers.addAll(weatherCityList.map((we) => we.weather));
            });
          });
        } else if (state is WeatherError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.8,
            child: _selectedIndex != null &&
                    _selectedIndex! < _locations.length &&
                    _selectedIndex! < _weathers.length
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _locations[_selectedIndex!]!.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _locations[_selectedIndex!]!.countryCode.toFlag,
                                style: const TextStyle(
                                  fontSize: 32,
                                ),
                              )
                            ],
                          ),
                          Text(
                            'Temperature: ${_weathers[_selectedIndex!]?.temperature.toString() ?? 'N/A'} °C',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Seleccione una ciudad',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (weatherCityList.isNotEmpty)
                  Card(
                    color: Colors.deepOrange,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${ciudadCaliente.name} ${ciudadCaliente.weather?.temperature} °C',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                if (weatherCityList.isNotEmpty)
                  Card(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${ciudadFria.name} ${ciudadFria.weather?.temperature} °C',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                if (weatherCityList.isNotEmpty)
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${weatherCityList.length} ${weatherCityList.length == 1 ? 'Ciudad' : 'Ciudades'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: WeatherCardList(
              weatherCityList: weatherCityList,
              selectedIndex: _selectedIndex,
              onCardSelected: _onCardSelected,
            ),
          ),
        ],
      ),
    );
  }
}
