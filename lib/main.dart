import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/cars/cars_bloc.dart';
import 'package:green_cars/data/repository/car/car.dart';
import 'package:green_cars/presentation/pages/homepage.dart';
import 'package:green_cars/presentation/theme/style.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/home/nav/navigation_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CarRepository carStorageRepo = CarRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          //cubit for navigation
          create: (context) => NavigationCubit(), //create the cubit itself
        ),
        BlocProvider<CarsBloc>(create: (context) => CarsBloc(carStorageRepo)),
      ],
      child: MaterialApp(
        title: 'GreenCars',
        theme: appTheme(),
        home: const HomePage(),
      ),
    );
  }
}
