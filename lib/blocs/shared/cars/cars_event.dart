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

class UpdateCarsState extends CarsEvent {
  final int percent;
  final String id;

  const UpdateCarsState(this.percent, this.id);

  @override
  List<Object> get props => [percent];
}
