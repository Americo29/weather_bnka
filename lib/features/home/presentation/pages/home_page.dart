import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/features/auth/presentation/pages/login_page.dart';
import 'package:weather_bnka/features/home/presentation/widgets/cities_list_cards.dart';
import 'package:weather_bnka/features/home/presentation/widgets/weather_details.dart';
import 'package:weather_bnka/l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToWeatherDetails() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  void _logout() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(LogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogout) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const LoginPage()),
            ModalRoute.withName('/login'),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton.outlined(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              tooltip: l10n.logoutTooltip,
            ),
          ],
        ),
        body: _selectedIndex == 0
            ? const WeatherDetails()
            : CitiesListCards(onCityFavorite: _navigateToWeatherDetails),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.location_city),
              label: l10n.navCities,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
