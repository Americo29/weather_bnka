import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bnka/core/util/utils.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/features/home/presentation/widgets/weather_cards.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({super.key});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  List<WeatherCity> _cities = [];

  /// Catalogue name of the city on the detail panel. Held by name, not by
  /// index, so removing a card cannot silently move the selection elsewhere.
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    // This widget is rebuilt from scratch on every tab switch, so seed it from
    // what the bloc already holds. It cannot be asked for a replay: bloc drops
    // a state equal to the current one, so the listener would never fire.
    _cities = List.of(context.read<WeatherBloc>().weatherCityList);
    _selectedCity = _cities.where((c) => c.isLoaded).map((c) => c.name).lastOrNull;
  }

  void _onCardSelected(WeatherCity city) {
    setState(() => _selectedCity = city.name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherFavCitiesLoaded) {
          setState(() => _cities = state.weatherCityList);
        } else if (state is WeatherCityLoaded) {
          // Only a completed load takes over the panel.
          setState(() => _selectedCity = state.city);
        } else if (state is WeatherError) {
          // The selection is left alone on purpose: whatever was on screen
          // before is still the only thing we can honestly show.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).weatherLoadError)),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.8,
            child: _DetailPanel(city: _selected),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _Summary(cities: _loaded),
          ),
          Expanded(
            child: WeatherCardList(
              weatherCityList: _cities,
              selectedCity: _selectedCity,
              onCardSelected: _onCardSelected,
            ),
          ),
        ],
      ),
    );
  }

  /// The selected city, but only once its forecast actually arrived.
  WeatherCity? get _selected {
    for (final city in _cities) {
      if (city.name == _selectedCity && city.isLoaded) return city;
    }
    return null;
  }

  List<WeatherCity> get _loaded =>
      _cities.where((city) => city.isLoaded).toList();
}

class _DetailPanel extends StatelessWidget {
  final WeatherCity? city;

  const _DetailPanel({required this.city});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final city = this.city;
    if (city == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            l10n.noCitySelected,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  city.location!.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  city.location!.countryCode.toFlag,
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            ),
            Text(
              l10n.temperature('${city.weather!.temperature}'),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  /// Only cities whose forecast arrived; a pending one has no temperature to
  /// compare against.
  final List<WeatherCity> cities;

  const _Summary({required this.cities});

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final hottest = cities.reduce((a, b) =>
        a.weather!.temperature > b.weather!.temperature ? a : b);
    final coldest = cities.reduce((a, b) =>
        a.weather!.temperature < b.weather!.temperature ? a : b);

    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        _Chip(
          color: Colors.deepOrange,
          label: l10n.hottestCity(
              hottest.name, '${hottest.weather!.temperature}'),
          textColor: Colors.white,
        ),
        _Chip(
          color: Colors.blue,
          label: l10n.coldestCity(
              coldest.name, '${coldest.weather!.temperature}'),
          textColor: Colors.white,
        ),
        _Chip(label: l10n.cityCount(cities.length)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final Color? color;
  final String label;
  final Color? textColor;

  const _Chip({required this.label, this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label,
            style: TextStyle(fontSize: 12, color: textColor)),
      ),
    );
  }
}
