import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/cars/cars_bloc.dart';
import 'package:green_cars/data/models/car.dart';
import 'package:green_cars/presentation/pages/home/screens/sharedelements/addcar_dialog.dart';

class CarsHome extends StatelessWidget {
  const CarsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _carNameController = TextEditingController();
    final _carkwhController = TextEditingController();
    final _carpMaxACController = TextEditingController();
    final _carpMaxDCController = TextEditingController();
    final _carEfficiencyController = TextEditingController();
    return Center(
      child: Column(children: [
        const Expanded(
          flex: 8,
          child: CarsList(),
        ),
        Expanded(
          flex: 2,
          child: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: FloatingActionButton(
                elevation: 100,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Center(
                          child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: AddCarDialog(
                                carNameController: _carNameController,
                                carpMaxACController: _carpMaxACController,
                                carpMaxDCController: _carpMaxDCController,
                                carEfficiencyController:
                                    _carEfficiencyController,
                                carkwhController: _carkwhController,
                              ))));
                },
                child: const Icon(Icons.add),
              )),
        )
      ]),
    );
  }
}

class CarsList extends StatelessWidget {
  const CarsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsBloc, CarsState>(
      builder: (context, state) {
        if (state is CarsLoaded) {
          if (state.listOfCars.isEmpty) {
            return const Center(
              child: Text("Add a car"),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.listOfCars.length,
                      itemBuilder: (context, index) {
                        return carItem(car: state.listOfCars[index]);
                      }),
                )
              ],
            );
          }
        }
        return Text("Error" + state.toString());
      },
    );
  }

  Widget carItem({required Car car}) {
    return BlocBuilder<CarsBloc, CarsState>(builder: (context, state) {
      return Card(
          shadowColor: Colors.green,
          elevation: 15,
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            car.name,
                            textScaleFactor: 1.3,
                          ),
                          Text(
                            "kWh : " + car.kwh.toString(),
                            textScaleFactor: 1.3,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "DC power: " + car.pMaxDC.toString(),
                            textScaleFactor: 1.3,
                          ),
                          Text(
                            "AC power: " + car.pMaxDC.toString(),
                            textScaleFactor: 1.3,
                          ),
                          Text(
                            "Efficiency: " + car.efficiency.toString(),
                            textScaleFactor: 1.3,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Edit")),
                        ElevatedButton(
                            onPressed: () {
                              context.read<CarsBloc>().add(RemoveCars(car.id));
                            },
                            child: const Text("Remove")),
                      ],
                    )
                  ])),
            ],
          ));
    });
  }
}
