import 'package:uuid/uuid.dart';

import '../../models/car.dart';

class CarRepository {
  final uuid = const Uuid();
  List<Car> carList = [];

  List<Car> addCar(String carName, int carkwh, int carPMaxAC, int carPMaxDC,
      int carEfficiency) {
    final car = Car(
        id: uuid.v4(),
        pMaxAC: carPMaxAC,
        kwh: carkwh,
        name: carName,
        pMaxDC: carPMaxDC,
        efficiency: carEfficiency);
    carList.add(car);
    return carList;
  }

  List<Car> removeCar(String id) {
    carList.removeWhere((element) => element.id == id);
    return carList;
  }

  List<Car> updateCar(var value, int what, String id) {
    for (Car element in carList) {
      if (element.id == id) {
        if (what == 0) {
          element.name = value;
        } else if (what == 1) {
          element.pMaxAC = value;
        }
      }
    }
    return carList;
  }
}
