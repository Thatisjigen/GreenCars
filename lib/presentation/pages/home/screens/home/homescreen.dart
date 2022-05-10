import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:green_cars/presentation/pages/home/elements/maps_widget.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/booking_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    Ticket _ticket = Ticket();
    return BlocProvider<TicketsBloc>(create: (context)=>TicketsBloc(_ticket),
      child: Container(
      child: Column(
        children: [
          Expanded(child: mapsView,flex: 4,),
          Expanded(child: ElevatedButton(
              onPressed: () {},
              child: Text("Send request")),
          ),
          Expanded(child: bookingView,flex: 4,),
        ],
      ),
    ),
    );
    }
  get mapsView => mapsWidget;

  get bookingView => BookingWidget();
}

