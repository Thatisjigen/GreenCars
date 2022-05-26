import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/home/nav/navigation_cubit.dart';
import 'package:green_cars/blocs/home/nav/states.dart';

PreferredSizeWidget homeAppbar({required Text title}) {
  return AppBar(
    centerTitle: true,
    surfaceTintColor: Colors.white70,
    elevation: 30,
    leading: const Padding(
      padding: EdgeInsets.only(left: 140),
      child: Icon(
        Icons.energy_savings_leaf,
        size: 35,
        color: Colors.green,
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
    ),
    toolbarHeight: 60,
    foregroundColor: Colors.black,
    backgroundColor: Colors.white70,
    title: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
      if (state.navbarItem == NavbarItem.home) {
        return const Text("Home");
      } else if (state.navbarItem == NavbarItem.settings) {
        return const Text("Tickets");
      } else if (state.navbarItem == NavbarItem.profile) {
        return const Text("Cars");
      }
      return const Text("");
    }),
  );
}

Widget get drawer {
  return const Drawer(
    elevation: 10,
//child: button,
  );
}

Widget get bottomNavigationBar {
  return BlocBuilder<NavigationCubit, NavigationState>(
    builder: (context, state) {
      return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(60), topLeft: Radius.circular(60)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, spreadRadius: 30, blurRadius: 100),
            ],
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: BottomNavigationBar(
                selectedItemColor: Colors.green,
                currentIndex: state.index,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.book_online,
                    ),
                    label: 'Tickets',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.directions_car_filled,
                    ),
                    label: 'Cars',
                  ),
                ],
                onTap: (index) {
                  if (index == 0) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.home);
                  } else if (index == 1) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.settings);
                  } else if (index == 2) {
                    BlocProvider.of<NavigationCubit>(context)
                        .getNavBarItem(NavbarItem.profile);
                  }
                },
              )));
    },
  );
}
