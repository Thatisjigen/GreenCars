import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/cars/cars_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/data/models/car.dart';

import '../../sharedelements/addcar_dialog.dart';

class BookingWidget extends StatelessWidget {
  const BookingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsBloc, CarsState>(builder: (context, carsState) {
      print(context.toString());
      //CarState as a State
      if (carsState is CarsLoaded) {
        return WithCarsWidget(
          stateOfCars: carsState,
        );
      }
      return withoutCarsWidget;
    });
  }
}

// ignore: must_be_immutable
class WithCarsWidget extends StatelessWidget {
  CarsLoaded stateOfCars;
  final _carNameController = TextEditingController();
  final _carpMaxDCController = TextEditingController();
  final _carpMaxACController = TextEditingController();
  final _carEfficiencyController = TextEditingController();

  WithCarsWidget({Key? key, required this.stateOfCars}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var selectedval;

    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      if (stateOfCars.listOfCars.isNotEmpty) {
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Choose your car",
                          textScaleFactor: 1.2,
                        ),
                        DropdownButton(
                            value: selectedval == null
                                ? stateOfCars.listOfCars[0]
                                : state.ticket.car,
                            onChanged: (value) {
                              selectedval = value as Car;
                              context
                                  .read<TicketsBloc>()
                                  .add(UpdateTicket(selectedval, 1));
                            },
                            items: stateOfCars.listOfCars
                                .map<DropdownMenuItem<Car>>((Car value) {
                              return DropdownMenuItem<Car>(
                                value: value,
                                child: Text(
                                    value.name + ' ' + value.name,)//todo: implement a readable list (not here, in the car page)
                              );
                            }).toList()),
                      ])),
              CarTicketCommon(state: state),
            ]);
      } else {
        return SingleChildScrollView(
          child: BookingWithNocar(
            carNameController: _carNameController,
            state: state,
            carState: stateOfCars,
            carEfficiencyController: _carEfficiencyController,
            carpMaxACController: _carpMaxACController,
            carpMaxDCController: _carpMaxDCController,
          ),
        );
      }
    });
  }
}

class BookingWithNocar extends StatelessWidget {
  final CarsLoaded carState;
  final TextEditingController carNameController;
  final TextEditingController carpMaxDCController;
  final TextEditingController carpMaxACController;
  final TextEditingController carEfficiencyController;

  final TicketsState state;
  const BookingWithNocar(
      {Key? key,
      required this.state,
      required this.carState,
        required this.carNameController,
        required this.carpMaxDCController,
        required this.carpMaxACController,
        required this.carEfficiencyController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add your car",
                    textScaleFactor: 1.2,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green, onPrimary: Colors.white),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Center(
                                  child: SingleChildScrollView(
                                padding: const EdgeInsets.all(20),
                                child: AddCarDialog(
                                  carNameController: carNameController,
                                  carEfficiencyController: carEfficiencyController,
                                  carpMaxACController: carpMaxACController,
                                  carpMaxDCController: carpMaxDCController,
                                ),
                              )));
                    },
                    child: const Text("Add a car please"),
                  )
                ]),
          ),
          CarTicketCommon(state: state),
        ]);
  }
}

// ignore: must_be_immutable
class CarTicketCommon extends StatelessWidget {
  TicketsState state;
  CarTicketCommon({Key? key, required this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(
        color: Colors.transparent,
      ),
      Column(children: [
        const Text(
          "Select your car charged percent:",
          textAlign: TextAlign.center,
          textScaleFactor: 1.2,
        ),
        Slider(
          activeColor: Colors.green,
          inactiveColor: Colors.green.shade300,
          thumbColor: Colors.green,
          label: state.ticket.percentage.toString(),
          divisions: 100,
          min: 0.0,
          max: 100.0,
          onChanged: (value) =>
              {context.read<TicketsBloc>().add(UpdateTicket(value.toInt(), 0))},
          value: state.ticket.percentage.toDouble(),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("0"),
                Text("100"),
              ],
            ))
      ]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "How many mt do you want to walk?",
              textAlign: TextAlign.center,
              textScaleFactor: 1.2,
            ),
            Slider(
              activeColor: Colors.green,
              inactiveColor: Colors.green.shade300,
              thumbColor: Colors.green,
              label: state.ticket.maxMeters.toString(),
              divisions: 100,
              min: 0.0,
              max: 2000.0,
              onChanged: (value) => {
                context.read<TicketsBloc>().add(UpdateTicket(value.toInt(), 2))
              },
              value: state.ticket.maxMeters.toDouble(),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("0 m"),
                    Text("2km"),
                  ],
                ))
          ]),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Expanded(
              child: Text(
            "Being 'Green' let you pay less but walk more. Enable to be green",
            textScaleFactor: 1.2,
          )),
          Switch(
            value: state.ticket.green,
            onChanged: (value) =>
                {context.read<TicketsBloc>().add(UpdateTicket(value, 3))},
          ),
        ]),
      ),
      const Divider(color: Colors.transparent),
    ]);
  }
}

Widget get withoutCarsWidget => const CircularProgressIndicator(
      color: Colors.green,
    );
