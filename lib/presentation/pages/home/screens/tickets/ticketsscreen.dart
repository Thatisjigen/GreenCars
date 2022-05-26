import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/validtickets/valid_ticket_bloc.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:green_cars/presentation/pages/home/elements/charge_chart.dart';
import 'package:green_cars/presentation/pages/home/screens/sharedelements/expandable_card.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TicketsView extends StatefulWidget {
  const TicketsView({Key? key}) : super(key: key);

  @override
  TicketsViewState createState() => TicketsViewState();
}

class TicketsViewState extends State<TicketsView> {
  TicketsViewState({Key? key});
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValidTicketBloc, ValidTicketState>(
        builder: (context, state) {
      if (state is TicketsLoaded) {
        if (state.listOfTicket.isEmpty) {
          return const Center(
            child: Text("Empty"),
          );
        } else {
          return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Column(children: [
                const Text("Your tickets: "),
                Align(
                    alignment: Alignment.topCenter,
                    child: _columnListView(
                      context,
                      list: state.listOfTicket,
                    ))
              ])));
        }
      }
      return const Center(
        child: Text("No ticket booked yet"),
      );
    });
  }

  Widget _columnListView(BuildContext context,
      {required List<BookedTicket> list}) {
    for (var element in list) {
      if (DateTime.parse(element.date).isBefore(DateTime.now())) {
        context.read<ValidTicketBloc>().add(RemoveTickets(element.id));
      }
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ticketItem(ticket: list[index]);
        });
  }

  Widget ticketItem({required BookedTicket ticket}) {
    return InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: ExpandableCardContainer(
          collapsedChild: ticketValidCollapsed(ticket),
          expandedChild: ticketValidExpanded(ticket),
          isExpanded: isExpanded,
        ));
  }

  Widget ticketValidExpanded(BookedTicket ticket) {
    final List<ChartElement> data = [];
    String unifiedState = ticket.column.chargingState!;
    var chargepointValues = unifiedState.split('T');
    Color chargecolor;
    for (int i = 0; i < chargepointValues.length; i++) {
      if (int.parse(chargepointValues[i]) < 30) {
        chargecolor = Colors.red;
      } else if (int.parse(chargepointValues[i]) < 70) {
        chargecolor = Colors.amber;
      } else {
        chargecolor = Colors.green;
      }
      data.insert(
          i,
          ChartElement(
              time: DateTime.parse(ticket.date).add(Duration(minutes: i * 15)),
              barColor: charts.ColorUtil.fromDartColor(chargecolor),
              chargePercent: int.parse(chargepointValues[i])));
    }

    return Card(
        shadowColor: Colors.white70,
        elevation: 15,
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(
          children: [
            Column(children: [
              Text(ticket.column.address!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Price: " + ticket.column.price! + "€"),
                  Text("Leaving SoC: " +
                      ticket.column.finalSoC!.toInt().toString() +
                      "%")
                ],
              ),
              SizedBox(
                height: 330,
                child: ChargeChart(
                  data: data,
                ),
              ),
            ]),
          ],
        ));
  }

  Widget ticketValidCollapsed(BookedTicket ticket) {
    DateTime datetime = DateTime.parse(ticket.date);
    String date = datetime.day.toString() +
        "/" +
        datetime.month.toString() +
        "/" +
        datetime.year.toString();
    String hour = datetime.hour.toString() + ":" + datetime.minute.toString();

    return Card(
        shadowColor: Colors.white70,
        elevation: 15,
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: SizedBox(
          height: 100,
          child: Column(children: [
            Text(ticket.column.address!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  date,
                  textScaleFactor: 1.3,
                ),
                Text(
                  hour,
                  textScaleFactor: 1.3,
                )
              ],
            ),
          ]),
        ));
  }
}
