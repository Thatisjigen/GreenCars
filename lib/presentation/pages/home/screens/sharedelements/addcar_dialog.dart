import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/cars/cars_bloc.dart';

// ignore: must_be_immutable
class AddCarDialog extends StatelessWidget {
  TextEditingController carNameController;
  TextEditingController carKwhController;
  AddCarDialog(
      {Key? key,
      required this.carNameController,
      required this.carKwhController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      insetPadding: const EdgeInsets.symmetric(vertical: 330, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What car do you want to create?",
            textScaleFactor: 1.2,
          ),
          TextField(
            controller: carNameController,
          ),
          const Text(
            "How much kwh is it powerful?",
            textScaleFactor: 1.2,
          ),
          TextField(
            controller: carKwhController,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<CarsBloc>().add(AddCars(
                    carNameController.text, int.parse(carKwhController.text)));
                Navigator.of(context).pop(context);
              },
              child: const Text('SAVE'))
        ],
      ),
    );
  }
}
