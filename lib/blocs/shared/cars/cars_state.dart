part of 'cars_bloc.dart';

abstract class CarsState extends Equatable {
  const CarsState();

  @override
  List<Object> get props => [];

  Map<String, dynamic>? toJson() {
    return null;
  }
}

class CarsLoading extends CarsState {}

class CarsLoaded extends CarsState {
  final List<Car> listOfCars;

  const CarsLoaded(this.listOfCars);

  @override
  List<Object> get props => [listOfCars];

  @override
  Map<String, dynamic> toJson() {
    return {'Cars': listOfCars};
  }
}
