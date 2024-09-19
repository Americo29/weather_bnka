import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:weather_bnka/features/auth/data/data_sources/shared_pref_helper.dart';
import 'package:weather_bnka/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:weather_bnka/features/auth/presentation/pages/login_page.dart';
import 'package:weather_bnka/features/home/presentation/bloc/weather_bloc.dart';
import 'package:weather_bnka/features/home/presentation/widgets/cities_list_cards.dart';
import 'package:weather_bnka/features/home/presentation/widgets/weather_details.dart';
import 'package:weather_bnka/injection_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final sharedPrefHelper = GetIt.instance<SharedPrefHelper>();
  @override
  void initState() {
    super.initState();
  }

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
                color: Colors.amber),
          ],
        ),
        body: BlocProvider<WeatherBloc>(
          create: (context) => getIt<WeatherBloc>(),
          child: _selectedIndex == 0
              ? const WeatherDetails()
              : CitiesListCards(onCityFavorite: _navigateToWeatherDetails),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueGrey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_city),
              label: 'Cities',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
