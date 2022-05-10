import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/maps_widget.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/booking_widget.dart';

//Todo: implement a valid ticket request and print the missing fields in the central widget.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Ticket _ticket = Ticket();
    return BlocProvider<TicketsBloc>(
      create: (context) => TicketsBloc(_ticket),
      child: Column(
        children: [
          Expanded(
            child: mapsView,
            flex: 8,
          ),
          const Divider(
            color: Colors.green,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Book your column: ",
                      textScaleFactor: 1.5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green, onPrimary: Colors.white),
                      onPressed: () {},
                      child: const Text("Send request"),
                    ),
                  ]),
            ),
          ),
          const Divider(
            color: Colors.green,
          ),
          Expanded(
            child: bookingView,
            flex: 8,
          ),
        ],
      ),
    );
  }

  get mapsView => mapsWidget;

  get bookingView => const BookingWidget();
}
