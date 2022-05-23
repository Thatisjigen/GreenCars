import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/cars/cars_bloc.dart';

// ignore: must_be_immutable
class AddCarDialog extends StatelessWidget {
  TextEditingController carNameController;
  TextEditingController carkwhController;
  TextEditingController carpMaxACController;
  TextEditingController carpMaxDCController;
  TextEditingController carEfficiencyController;
  AddCarDialog({
    Key? key,
    required this.carNameController,
    required this.carkwhController,
    required this.carpMaxACController,
    required this.carpMaxDCController,
    required this.carEfficiencyController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool _validateName = true;
    bool _validateKwh = true;
    bool _validateAC = true;
    bool _validateDC = true;
    bool _validateEff = true;

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
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              labelText: 'Enter your car name',
              errorText:
                  _validateName == true ? null : "Please insert a valid name",
            ),
            controller: carNameController,
          ),
          const Text(
            "How much kwh is the battery capable?",
            textScaleFactor: 1.2,
          ),
          TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              labelText: 'Enter your battery pwr( 10-200 )',
            ),
            controller: carkwhController,
          ),
          const Text(
            "How much pMaxAC is supported?",
            textScaleFactor: 1.2,
          ),
          TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              labelText: 'Enter your car max AC charging power (1-50)',
            ),
            controller: carpMaxACController,
          ),
          const Text(
            "How much pMaxDC is supported?", //Todo: fix the string
            textScaleFactor: 1.2,
          ),
          TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              labelText: 'Enter your car max DC charging power (1-150)',
            ),
            controller: carpMaxDCController,
          ),
          const Text(
            "How much is it efficient? (kWh/km)",
            textScaleFactor: 1.2,
          ),
          TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              labelText: 'Enter your car efficiency (1-30)',
            ),
            controller: carEfficiencyController,
          ),
          ElevatedButton(
              onPressed: () {
                carNameController.text.isEmpty
                    ? _validateName = false
                    : _validateName = true;
                _validateKwh = (int.parse(carkwhController.text) > 9 &&
                    int.parse(carkwhController.text) < 201);
                _validateAC = (int.parse(carpMaxACController.text) > 0 &&
                    int.parse(carpMaxACController.text) < 50);
                _validateDC = (int.parse(carpMaxDCController.text) > 0 &&
                    int.parse(carpMaxDCController.text) < 150);
                _validateEff = (int.parse(carEfficiencyController.text) > 0 &&
                    int.parse(carEfficiencyController.text) < 30);
                if (_validateName &&
                    _validateKwh &&
                    _validateAC &&
                    _validateDC &&
                    _validateEff) {
                  context.read<CarsBloc>().add(AddCars(
                      carNameController.text,
                      int.parse(carkwhController.text),
                      int.parse(carpMaxACController.text),
                      int.parse(carpMaxDCController.text),
                      int.parse(carEfficiencyController.text)));
                  Navigator.of(context).pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => MissingCarFieldsDialog(
                        name: _validateName,
                        kwh: _validateKwh,
                        ac: _validateAC,
                        dc: _validateDC,
                        eff: _validateEff),
                  );
                }
              },
              child: const Text('SAVE'))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MissingCarFieldsDialog extends StatelessWidget {
  String error = "The following fields are not valid:";
  bool name, kwh, ac, dc, eff;
  MissingCarFieldsDialog(
      {Key? key,
      required this.name,
      required this.kwh,
      required this.ac,
      required this.dc,
      required this.eff})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!name) {
      error = error + "name ";
    }
    if (!kwh) {
      error = error + "kWh ";
    }
    if (!ac) {
      error = error + "AC power ";
    }
    if (!dc) {
      error = error + "DC power ";
    }
    if (!eff) {
      error = error + "efficiency ";
    }
    return Dialog(
        elevation: 10,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 390),
        child: Center(
          child: Column(children: [
            Text(
              error,
              textScaleFactor: 1.2,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(context);
              },
              child: const Text("Back"),
            ),
          ]),
        ));
  }
}
