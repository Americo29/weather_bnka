import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherCardList extends StatelessWidget {
  final List<WeatherCity> weatherCityList;

  /// Catalogue name of the selected city, or null when none is selected.
  final String? selectedCity;
  final ValueChanged<WeatherCity> onCardSelected;

  const WeatherCardList({
    super.key,
    required this.weatherCityList,
    required this.onCardSelected,
    this.selectedCity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 4 / 2,
        ),
        itemCount: weatherCityList.length,
        itemBuilder: (context, index) {
          final weatherCity = weatherCityList[index];
          final isSelected = weatherCity.name == selectedCity;

          return GestureDetector(
            // A city that is still loading cannot be selected: there is
            // nothing to show for it yet.
            onTap: weatherCity.isLoaded
                ? () => onCardSelected(weatherCity)
                : null,
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
                        padding: const EdgeInsets.all(4),
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.black38,
                          size: 20,
                        ),
                        // Removing a city mid-request would leave the pending
                        // response with nothing to land on.
                        onPressed: weatherCity.isLoading
                            ? null
                            : () => context
                                .read<WeatherBloc>()
                                .add(RemoveWeatherFavCity(weatherCity.name)),
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
                    padding: const EdgeInsets.only(left: 14.0, top: 4.0),
                    child: _CardStatus(weatherCity: weatherCity),
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

class _CardStatus extends StatelessWidget {
  final WeatherCity weatherCity;

  const _CardStatus({required this.weatherCity});

  @override
  Widget build(BuildContext context) {
    if (weatherCity.isLoading) {
      return const SizedBox(
        key: ValueKey('card-spinner'),
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final weather = weatherCity.weather;
    if (weather == null) {
      return const Text('Datos no disponibles');
    }

    return Text(
      'Temperatura: ${weather.temperature} °C',
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
    );
  }
}
