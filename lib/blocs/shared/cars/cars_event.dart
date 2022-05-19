part of 'cars_bloc.dart';

abstract class CarsEvent extends Equatable {
  const CarsEvent();

  @override
  List<Object> get props => [];
}

class AddCars extends CarsEvent {
  final String carName;
  final int carPMaxAC;
  final int carPMaxDC;
  final int carEfficiency;

  const AddCars(
      this.carName, this.carPMaxAC, this.carPMaxDC, this.carEfficiency);

  @override
  List<Object> get props => [carName, carPMaxAC, carPMaxDC, carEfficiency];
}

class RemoveCars extends CarsEvent {
  final String id;

  const RemoveCars(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateCars extends CarsEvent {
  final int what;
  final String id;
  final String value;

  const UpdateCars(this.value, this.what, this.id);

  @override
  List<Object> get props => [id];
}
