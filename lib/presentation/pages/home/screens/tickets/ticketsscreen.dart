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
  List<ExpandedColumnsState> isExpanded = [];
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
                  physics: const ScrollPhysics(),
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text(
                        "Your tickets: ",
                        textScaleFactor: 1.3,
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: _columnListView(
                              context,
                              list: state.listOfTicket,
                            )))
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
    ScrollController _controller = ScrollController();

    for (var element in list) {
      if (DateTime.parse(element.date).isBefore(DateTime.now())) {
        context.read<ValidTicketBloc>().add(RemoveTickets(element.id));
      }
      isExpanded.add(ExpandedColumnsState(
        expanded: false,
        uuid: element.id,
      ));
    }
    return SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return ticketItem(ticket: list[index]);
            }));
  }

  Widget ticketItem({required BookedTicket ticket}) {
    return InkWell(
        onTap: () {
          final tile = isExpanded.firstWhere((item) => item.uuid == ticket.id);
          setState(() => tile.expanded = tile.expanded == true ? false : true);
        },
        child: ExpandableCardContainer(
          collapsedChild: ticketValidCollapsed(ticket),
          expandedChild: ticketValidExpanded(ticket),
          isExpanded:
              isExpanded.firstWhere((item) => item.uuid == ticket.id).expanded,
        ));
  }

  Widget ticketValidExpanded(BookedTicket ticket) {
    final List<ChartElement> data = [];
    String unifiedState = ticket.chargingState;
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
        child: Column(
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  ticket.address,
                  textScaleFactor: 1.3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Price: " + ticket.price + "€",
                      textScaleFactor: 1.3,
                    ),
                    Text(
                      "Leaving SoC: " + ticket.leavingSoC + "%",
                      textScaleFactor: 1.3,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 330,
                child: ChargeChart(
                  data: data,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                ticket.address,
                textScaleFactor: 1.3,
              ),
            ),
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

class ExpandedColumnsState {
  bool expanded;
  String uuid;
  ExpandedColumnsState({required this.expanded, required this.uuid});
}
