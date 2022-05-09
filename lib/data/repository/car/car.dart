import 'package:uuid/uuid.dart';

import '../../models/car.dart';

class CarRepository {
  final uuid = const Uuid();
  List<Car> carList = [];

  List<Car> addCar(String carName,int carKwh) {
    final car = Car(id: uuid.v4(), kwh: carKwh, name: carName);
    carList.add(car);
    return carList;
  }

  List<Car> removeCar(String id) {
    carList.removeWhere((element) => element.id == id);
    return carList;
  }

  List<Car> updateCarPercentage(int percent, String id) {
    for (Car element in carList) {
      if (element.id == id) {
        element.percentage = percent;
      }
    }
    return carList;
  }
}