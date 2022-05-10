import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/cars/cars_bloc.dart';
import 'package:green_cars/data/models/car.dart';
import 'package:uuid/uuid.dart';


class CarsHome extends StatelessWidget {
  const CarsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _carNameController = TextEditingController();
    final _carKwhController = TextEditingController();

    return Center(
      child: Column(children: [
        CarsList(),
        FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                        child: Column(
                      children: [
                        const Text("What car do you want to create?"),
                        TextField(
                          controller: _carNameController,
                        ),
                        const Text("How much kwh is it powerful?"),
                        TextField(
                          controller: _carKwhController,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              var uuid = const Uuid();
                              context.read<CarsBloc>().add(AddCars(
                                  _carNameController.text,
                                  int.parse(_carKwhController.text)));
                              Navigator.of(context).pop(context);
                            },
                            child: const Text('SAVE'))
                      ],
                    )));
          },
          child: const Icon(Icons.add),
        ),
      ]),
    );
  }
}

class CarsList extends StatelessWidget {
  CarsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsBloc, CarsState>(
      builder: (context, state) {
        if (state is CarsLoaded) {
          if (state.listOfCars.isEmpty) {
            return const Center(
              child: Text("Add new Cars"),
            );
          } else {
            return Expanded(child:
            Column(
              mainAxisSize: MainAxisSize.max,
                children: [ Expanded(
                  child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.listOfCars.length,
                  itemBuilder: (context, index) {
                    final content = state.listOfCars[index];
                    return CarItem(car: state.listOfCars[index]);
                  }
                  ),
                )
                ]
            ),
            );
          }
        }
        return Text("Error" + state.toString());
      },
    );
  }

  Widget CarItem({required Car car}) {
    return Row(
      children: [
        Text(car.name),
        Text(car.kwh.toString()),
      ],
    );
  }
}
