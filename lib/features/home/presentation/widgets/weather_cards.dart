import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';
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
          final scheme = Theme.of(context).colorScheme;
          // A selected card is painted with the primary colour, so its content
          // has to switch too -- inheriting onSurface leaves it at 1.71:1.
          final foreground =
              isSelected ? scheme.onPrimaryContainer : scheme.onSurface;

          return GestureDetector(
            // A city that is still loading cannot be selected: there is
            // nothing to show for it yet.
            onTap: weatherCity.isLoaded
                ? () => onCardSelected(weatherCity)
                : null,
            child: Card(
              color: isSelected ? scheme.primaryContainer : null,
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
                        icon: const Icon(Icons.delete_forever, size: 20),
                        color: foreground,
                        tooltip: weatherCity.name,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: foreground,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, top: 4.0),
                    child: _CardStatus(
                      weatherCity: weatherCity,
                      foreground: foreground,
                    ),
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
  final Color foreground;

  const _CardStatus({required this.weatherCity, required this.foreground});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (weatherCity.isLoading) {
      return Semantics(
        label: l10n.loadingCity(weatherCity.name),
        // 16px with a 2px stroke read as a dot rather than as activity, on the
        // device as much as in a screenshot. This is the smallest size at which
        // the sweep is legible next to 12sp text.
        child: SizedBox(
          key: const ValueKey('card-spinner'),
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: foreground),
        ),
      );
    }

    final weather = weatherCity.weather;
    if (weather == null) {
      return Text(l10n.dataUnavailable, style: TextStyle(color: foreground));
    }

    return Text(
      l10n.temperature('${weather.temperature}'),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: foreground,
      ),
    );
  }
}
