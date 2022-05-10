import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
//Todo: implement a bloc to read the settings values.
class BookingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(
        builder: (context, state) {
          if (state is TicketsUpdated) {
            return
              Column(
                  children: [
                    Slider(
                      label: "What's your battery status?(percent)",
                      divisions: 100,
                      min: 0.0,
                      max: 100.0,
                      onChanged: (value) =>
                      {context.read<TicketsBloc>().add(UpdateTicket(
                          value.toInt(), 0
                      ))},
                      value: state.ticket.percentage.toDouble(),
                    ),
                    Slider(
                      label: "How many mt do you want to walk?",
                      max: 100,
                      min: 0,
                      onChanged: (_) => {},
                      value: 0,
                    ),
                    Row(
                        children: [
                          Expanded(child: Text("Green or not?"), flex: 4,),
                          Expanded(child: Switch(value: false,
                              onChanged: (_) => {}
                          ),
                            flex: 1,
                          )
                        ]
                    ),
                  ]
              );
          }
            else return
            Column(
                children: [
                  Slider(
                    label: "What's your battery status?(percent)",
                    divisions: 100,
                    min: 0.0,
                    max: 100.0,
                    onChanged: (value) =>
                    {context.read<TicketsBloc>().add(UpdateTicket(
                        value.toInt(), 0
                    ))},
                    value: state.ticket.percentage.toDouble(),
                  ),
                  Slider(
                    label: "How many mt do you want to walk?",
                    max: 100,
                    min: 0,
                    onChanged: (_) => {},
                    value: 0,
                  ),
                  Row(
                      children: [
                        Expanded(child: Text("Green or not?"), flex: 4,),
                        Expanded(child: Switch(value: false,
                            onChanged: (_) => {}
                        ),
                          flex: 1,
                        )
                      ]
                  ),
                ]
            );
        }
    );
  }
}