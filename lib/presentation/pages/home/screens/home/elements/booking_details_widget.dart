import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';

// ignore: must_be_immutable
class AddDetailsDialog extends StatelessWidget {
  const AddDetailsDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ticket = BlocProvider.of<TicketsBloc>(context).state.ticket;

    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      return Dialog(
        elevation: 10,
        insetPadding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: DateTimeFormField(
                initialDate: DateTime.now(),
                lastDate: convertDate(DateTime.now()),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green,
                  hintStyle: const TextStyle(color: Colors.white70),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  hintText: '  Select your arrival time',
                  isDense: true,
                  //border: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                mode: DateTimeFieldPickerMode.dateAndTime,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onDateSelected: (DateTime value) {
                  context.read<TicketsBloc>().add(UpdateTicket(value, 7));
                },
              ),
            ),
            Slider(
              activeColor: Colors.green,
              inactiveColor: Colors.green.shade300,
              thumbColor: Colors.green,
              label: ticket.durationMinutes.toString(),
              //todo: is it working? :(
              divisions: 179,
              min: 10.0,
              max: 180.0,
              onChanged: (value) => {
                context.read<TicketsBloc>().add(UpdateTicket(value.toInt(), 8)),
              },
              value: ticket.durationMinutes.toDouble(),
            ),
            ElevatedButton(
                onPressed: () {},
                child: const Text('Send request')) //todo: call web service
          ],
        ),
      );
    });
  }

  DateTime convertDate(DateTime datetime) => DateTime(
      datetime.add(const Duration(days: 60)).year,
      datetime.add(const Duration(days: 60)).month,
      datetime.add(const Duration(days: 60)).day);
}
