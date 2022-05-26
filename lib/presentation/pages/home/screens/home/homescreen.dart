import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/booking_details_widget.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/booking_widget.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/maps_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? const PortraitHomeView()
            : const LandScapeHomeView());
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
    var ticket = BlocProvider.of<TicketsBloc>(context).state.ticket;

    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      return Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text(
              "Book your column: ",
              textScaleFactor: 1.5,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green, onPrimary: Colors.white),
                child: const Text("Add details"),
                onPressed: () {
                  bool validcar = false;
                  bool validPosition = false;
                  bool validPercent = false;
                  bool validMeter = false;
                  if (ticket.car.id != '-1') {
                    validcar = true;
                  }
                  if (ticket.latlon.latitude != -1) {
                    validPosition = true;
                  }
                  if (ticket.percentage != 100) {
                    validPercent = true;
                  }
                  if (ticket.maxMeters != 0) {
                    validMeter = true;
                  }
                  if (validcar && validPosition && validPercent && validMeter) {
                    showDialog(
                      context: context,
                      builder: (context) => const AddDetailsDialog(),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return InvalidFirstStageRequest(
                            validPos: validPosition,
                            validMeter: validMeter,
                            validPercent: validPercent,
                            validcar: validcar,
                          );
                        });
                  }
                })
          ]),
        ),
      );
    });
  }
}

// ignore: must_be_immutable
class InvalidFirstStageRequest extends StatelessWidget {
  bool validMeter;
  bool validPos;
  bool validPercent;
  bool validcar;

  InvalidFirstStageRequest({
    Key? key,
    required this.validPos,
    required this.validMeter,
    required this.validcar,
    required this.validPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String error = "The following field(s) are wrong:";
    if (!validMeter) {
      error = error + "mt ";
    }
    if (!validPos) {
      error = error + "position ";
    }
    if (!validcar) {
      error = error + "car ";
    }
    if (!validPercent) {
      error = error + "SoC";
    }

    return Dialog(
        elevation: 10,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 390),
        child: Center(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                error,
                textScaleFactor: 1.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                child: const Text("Back"),
              ),
            ),
          ]),
        ));
  }
}
