import 'package:equatable/equatable.dart';
import 'package:green_cars/data/models/car.dart';
import 'package:green_cars/data/repository/car/car.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'cars_event.dart';
part 'cars_state.dart';

class CarsBloc extends HydratedBloc<CarsEvent, CarsState> {
  final CarRepository carsRepository;

  CarsBloc(this.carsRepository) : super(CarsLoaded(carsRepository.carList)) {
    on<AddCars>((event, emit) async {
      emit(CarsLoading());
      final updatedCarsList = carsRepository.addCar(event.carName, event.carkwh,
          event.carPMaxAC, event.carPMaxDC, event.carEfficiency);
      emit(CarsLoaded(updatedCarsList));
    });
    on<RemoveCars>((event, emit) {
      emit(CarsLoading());
      final updatedCarsList = carsRepository.removeCar(event.id);
      emit(CarsLoaded(updatedCarsList));
    });
    on<UpdateCars>((event, emit) async {
      emit(CarsLoading());
      final updatedCarsList =
          carsRepository.updateCar(event.value, event.what, event.id);
      emit(CarsLoaded(updatedCarsList));
    });
  }

  @override
  CarsState? fromJson(Map<String, dynamic> json) {
    try {
      final listOfCars = (json['Cars'] as List)
          .map((e) => Car.fromJson(e as Map<String, dynamic>))
          .toList();

      carsRepository.carList = listOfCars;
      return CarsLoaded(listOfCars);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CarsState state) {
    if (state is CarsLoaded) {
      return state.toJson();
    } else {
      return null;
    }
  }
}
