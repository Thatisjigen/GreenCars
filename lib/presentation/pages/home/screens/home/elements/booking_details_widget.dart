import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/columnviewer_widget.dart';

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
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                  context
                      .read<TicketsBloc>()
                      .add(UpdateTicket(convertDateToticket(value), 7));
                },
              ),
            ),
            Column(children: [
              const Text(
                "How much minutes do you wanna stay?",
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
              Slider(
                activeColor: Colors.green,
                inactiveColor: Colors.green.shade300,
                thumbColor: Colors.green,
                label: ticket.durationMinutes.toString(),
                divisions: 11,
                min: 15.0,
                max: 180.0,
                onChanged: (value) => {
                  context
                      .read<TicketsBloc>()
                      .add(UpdateTicket(value.toInt(), 8)),
                },
                value: ticket.durationMinutes.toDouble(),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("15"),
                      Text("180"),
                    ],
                  ))
            ]),
            Column(children: [
              const Text(
                "What's the min charge you are going to accept?",
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
              ),
              Slider(
                activeColor: Colors.green,
                inactiveColor: Colors.green.shade300,
                thumbColor: Colors.green,
                label: ticket.targetPercentage.toString(),
                divisions: (100.0 - (ticket.percentage - 1)).toInt(),
                min: double.parse(ticket.percentage.toString()),
                max: 100.0,
                onChanged: (value) => {
                  context
                      .read<TicketsBloc>()
                      .add(UpdateTicket(value.toInt(), 5)),
                },
                value: ticket.targetPercentage.toDouble(),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ticket.percentage.toString()),
                      const Text("100"),
                    ],
                  ))
            ]),
            ElevatedButton(
                onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const AvailableColumnDialog(),
                    ),
                child: const Text('Send request'))
          ],
        ),
      );
    });
  }

  DateTime convertDateToticket(DateTime datetime) {
    if (datetime.minute > 0 && datetime.minute < 7) {
      return DateTime(
          datetime.year, datetime.month, datetime.day, datetime.hour, 00);
    }
    if (datetime.minute > 6 && datetime.minute < 15) {
      return DateTime(
          datetime.year, datetime.month, datetime.day, datetime.hour, 15);
    }
    if (datetime.minute > 15 && datetime.minute < 22) {
      return DateTime(
          datetime.year, datetime.month, datetime.day, datetime.hour, 15);
    }
    if (datetime.minute > 21 && datetime.minute < 30) {
      return DateTime(
          datetime.year, datetime.month, datetime.day, datetime.hour, 30);
    }
    if (datetime.minute > 30 && datetime.minute < 37) {
      return DateTime(
          datetime.year, datetime.month, datetime.day, datetime.hour, 30);
    }
    if (datetime.minute > 36 && datetime.minute < 45) {
      return DateTime(
          datetime.year, datetime.month, datetime.day, datetime.hour, 45);
    }
    if (datetime.minute > 45 && datetime.minute < 52) {
      return DateTime(
          datetime.year, datetime.month, datetime.day, datetime.hour, 45);
    }
    if (datetime.minute > 36 && datetime.minute < 45) {
      return DateTime(
          datetime.add(const Duration(hours: 1)).year,
          datetime.add(const Duration(hours: 1)).month,
          datetime.add(const Duration(hours: 1)).day,
          datetime.add(const Duration(hours: 1)).hour,
          00);
    }
    return datetime;
  }

  DateTime convertDate(DateTime datetime) => DateTime(
      datetime.add(const Duration(days: 60)).year,
      datetime.add(const Duration(days: 60)).month,
      datetime.add(const Duration(days: 60)).day);
}
