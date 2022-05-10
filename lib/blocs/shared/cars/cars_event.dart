part of 'cars_bloc.dart';

abstract class CarsEvent extends Equatable {
  const CarsEvent();

  @override
  List<Object> get props => [];
}

class AddCars extends CarsEvent {
  final String carName;
  final int carKwh;
  const AddCars(this.carName, this.carKwh);

  @override
  List<Object> get props => [carName, carKwh];
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
