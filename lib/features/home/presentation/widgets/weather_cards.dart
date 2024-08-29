import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/core/util/utils.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherCardList extends StatefulWidget {
  final List<WeatherCity> weatherCityList;
  final int? selectedIndex;
  final Function(int index) onCardSelected;

  const WeatherCardList({
    super.key,
    required this.weatherCityList,
    required this.onCardSelected,
    this.selectedIndex,
  });

  @override
  State<WeatherCardList> createState() => _WeatherCardListState();
}

class _WeatherCardListState extends State<WeatherCardList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _removeWeatherFavCity(String cityName) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(RemoveWeatherFavCity(cityName));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics:
            const AlwaysScrollableScrollPhysics(), // Ensure GridView scrolls properly
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 4 / 2,
        ),
        itemCount: widget.weatherCityList.length,
        itemBuilder: (context, index) {
          final weatherCity = widget.weatherCityList[index];
          final isSelected = widget.selectedIndex == index;
          final countryCode = weatherCity.location?.countryCode;

          return GestureDetector(
            onTap: () => widget.onCardSelected(index),
            child: Card(
              color: isSelected ? Colors.blue.shade100 : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                       
                        padding: const EdgeInsets.all(
                            4), 
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.black38,
                          size: 20, 
                        ),
                        onPressed: () =>
                            _removeWeatherFavCity(weatherCity.name),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      weatherCity.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: weatherCity.isLoading
                        ? const Text('...cargando',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300))
                        : weatherCity.weather != null
                            ? Text(
                                'Temperatura: ${weatherCity.weather!.temperature.toString()} °C',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                              )
                            : const Text('Datos no disponibles'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
