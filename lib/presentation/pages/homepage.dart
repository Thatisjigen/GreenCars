import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/home/nav/states.dart';
import 'package:green_cars/presentation/pages/home/screens/cars/profilescreen.dart';
import 'package:green_cars/presentation/pages/home/screens/home/homescreen.dart';
import 'package:green_cars/presentation/pages/home/screens/tickets/ticketsscreen.dart';

import '../../blocs/home/nav/navigation_cubit.dart';
import 'home/elements/bars_and_drawers.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar(title: const Text("GreenCars")),
      body: Center(
        child: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
          if (state.navbarItem == NavbarItem.home) {
            return const HomeScreen();
          } else if (state.navbarItem == NavbarItem.settings) {
            return const TicketsView();
          } else if (state.navbarItem == NavbarItem.profile) {
            return const CarsHome();
          }
          return const CircularProgressIndicator();
        }),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
