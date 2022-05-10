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
    final _carKwhController = TextEditingController();

    return Center(
      child: Column(children: [
        const CarsList(),
        FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AddCarDialog(
                    carNameController: _carNameController,
                    carKwhController: _carKwhController));
          },
          child: const Icon(Icons.add),
        ),
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
              child: Text("Add new Cars"),
            );
          } else {
            return Expanded(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.listOfCars.length,
                      itemBuilder: (context, index) {
                        return carItem(car: state.listOfCars[index]);
                      }),
                )
              ]),
            );
          }
        }
        return Text("Error" + state.toString());
      },
    );
  }

  Widget carItem({required Car car}) {
    return Row(
      children: [
        Text(car.name),
        Text(car.kwh.toString()),
      ],
    );
  }
}
