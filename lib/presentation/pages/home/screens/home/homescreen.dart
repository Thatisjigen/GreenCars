import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/booking_widget.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/maps_widget.dart';

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
        child: OrientationBuilder(
            builder: (context, orientation) =>
                orientation == Orientation.portrait
                    ? const PortraitHomeView()
                    : const LandScapeHomeView()));
  }
}

class PortraitHomeView extends StatelessWidget {
  const PortraitHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: mapsView,
          flex: 8,
        ),
        const Divider(
          color: Colors.green,
        ),
        const SendBookingRequest(),
        const Divider(
          color: Colors.green,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: bookingView,
          ),
          flex: 8,
        ),
      ],
    );
  }

  get mapsView => mapsWidget;

  get bookingView => const BookingWidget();
}

class LandScapeHomeView extends StatelessWidget {
  const LandScapeHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        flex: 9,
        child: Row(
          children: [
            Expanded(
              child: mapsView,
              flex: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: bookingView,
              ),
              flex: 8,
            ),
          ],
        ),
      ),
      const SendBookingRequest(),
    ]);
  }

  get mapsView => mapsWidget;

  get bookingView => const BookingWidget();
}

class SendBookingRequest extends StatelessWidget {
  const SendBookingRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
    );
  }
}
