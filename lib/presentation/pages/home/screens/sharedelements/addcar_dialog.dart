import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/cars/cars_bloc.dart';

// ignore: must_be_immutable
class AddCarDialog extends StatelessWidget {
  TextEditingController carNameController;
  TextEditingController carpMaxACController;
  TextEditingController carpMaxDCController;
  TextEditingController carEfficiencyController;
  AddCarDialog({
    Key? key,
    required this.carNameController,
    required this.carpMaxACController,
    required this.carpMaxDCController,
    required this.carEfficiencyController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
            "How much pMaxAC is it powerful?",
            textScaleFactor: 1.2,
          ),
          TextField(
            controller: carpMaxACController,
          ),
          const Text(
            "How much pMaxDC is it powerful?", //Todo: fix the string
            textScaleFactor: 1.2,
          ),
          TextField(
            controller: carpMaxDCController,
          ),
          const Text(
            "How much is it efficient?",
            textScaleFactor: 1.2,
          ),
          TextField(
            controller: carEfficiencyController,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<CarsBloc>().add(AddCars(
                    carNameController.text,
                    int.parse(carpMaxACController.text),
                    int.parse(carpMaxDCController.text),
                    int.parse(carEfficiencyController.text)));
                Navigator.of(context).pop(context);
              },
              child: const Text('SAVE'))
        ],
      ),
    );
  }
}
