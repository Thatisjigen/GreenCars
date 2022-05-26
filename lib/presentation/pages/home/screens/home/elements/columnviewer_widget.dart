import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/blocs/shared/validtickets/valid_ticket_bloc.dart';
import 'package:green_cars/data/models/columns.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:green_cars/presentation/pages/home/elements/charge_chart.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/maps/maps.dart';
import 'package:green_cars/presentation/pages/home/screens/sharedelements/expandable_card.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:green_cars/presentation/pages/home/screens/tickets/ticketsscreen.dart';

import 'package:http/http.dart' as http;

class AvailableColumnDialog extends StatefulWidget {
  const AvailableColumnDialog({Key? key}) : super(key: key);

  @override
  AvailableColumnDialogState createState() => AvailableColumnDialogState();
}

// ignore: must_be_immutable
class AvailableColumnDialogState extends State<AvailableColumnDialog> {
  AvailableColumnDialogState({
    Key? key,
  });
  final List<ExpandedColumnsState> _isExpanded = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      var ticket = BlocProvider.of<TicketsBloc>(context).state.ticket;

      return Dialog(
        elevation: 10,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 200),
        child: Center(
          child: columnsListBuilder(context, ticket),
        ),
      );
    });
  }

  List<JsonColumnModel> parseColumns(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<JsonColumnModel>((json) => JsonColumnModel.fromJson(json))
        .toList();
  }

  Future<List<JsonColumnModel>> fetchChargingColumns(
      http.Client client, ticket) async {
    final response =
        await client.get(Uri.parse(convertRequestFromTicket(ticket)));
    // Use the compute function to run parsePhotos in a separate isolate.
    return parseColumns(response.body);
  }

  Widget columnsListBuilder(BuildContext context, Ticket ticket) {
    return FutureBuilder<List<JsonColumnModel>>(
      future: fetchChargingColumns(http.Client(), ticket),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                const Padding(
                  padding: EdgeInsets.only(top: 230),
                  child: Text(
                    'No available columns',
                    textScaleFactor: 1.5,
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          return Navigator.of(context).pop(context);
                        },
                        child: const Text("Back")))
              ]));
        } else if (snapshot.hasData) {
          for (var element in snapshot.data!) {
            _isExpanded.add(ExpandedColumnsState(
              expanded: false,
              uuid: element.id!,
            ));
          }
          return Center(
              child: Column(children: [
            SizedBox(
              height: 440,
              child: _columnListView(context,
                  list: snapshot.data!, ticket: ticket),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () {
                      return Navigator.of(context).pop(context);
                    },
                    child: const Text("Back")))
          ]));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _columnListView(BuildContext context,
      {required List<JsonColumnModel> list, required ticket}) {
    list.sort((a, b) => a.finalSoC!.compareTo(b.finalSoC!));
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return columnItem(chargepoint: list[index], ticket: ticket);
        });
  }

  Widget columnItem(
      {required JsonColumnModel chargepoint, required Ticket ticket}) {
    double finalSoCpercent = chargepoint.finalSoC!.toDouble();
    LatLng target =
        LatLng(double.parse(chargepoint.lat!), double.parse(chargepoint.lon!));
    MapsScreenState.addMarker(target, chargepoint.id!);
    return InkWell(
        onTap: () {
          setState(() {
            final tile =
                _isExpanded.firstWhere((item) => item.uuid == chargepoint.id);
            setState(
                () => tile.expanded = tile.expanded == true ? false : true);
          });
        },
        child: ExpandableCardContainer(
          collapsedChild: ticketOfferCollapsed(finalSoCpercent, chargepoint),
          expandedChild:
              ticketOfferExpanded(finalSoCpercent, chargepoint, ticket.date),
          isExpanded: _isExpanded
              .firstWhere((item) => item.uuid == chargepoint.id)
              .expanded,
        ));
  }

  String convertRequestFromTicket(Ticket ticket) {
    int green = ticket.green ? 1 : 0;
    int startingKwh = ticket.percentage * ticket.car.kwh ~/ 100;
    String day, month, hour, minute;
    month = ticket.date.month.toString().length == 1
        ? "0" + ticket.date.month.toString()
        : ticket.date.month.toString();
    day = ticket.date.day.toString().length == 1
        ? "0" + ticket.date.day.toString()
        : ticket.date.day.toString();
    hour = ticket.date.hour.toString().length == 1
        ? "0" + ticket.date.hour.toString()
        : ticket.date.hour.toString();
    minute = ticket.date.minute.toString().length == 1
        ? "0" + ticket.date.minute.toString()
        : ticket.date.minute.toString();
    String date = ticket.date.year.toString() + "-" + month + "-" + day;
    String time = hour + ":" + minute;
    String duration = ticket.durationMinutes.toString();
    int targetMinKwh = ticket.targetPercentage * ticket.car.kwh ~/ 100;
    String request =
        'http://192.168.1.132:8888/green_cars-1.0-SNAPSHOT/ws/searchColumn/' +
            ticket.latlon.longitude.toString() +
            '/' +
            ticket.latlon.latitude.toString() +
            '/' +
            (ticket.maxMeters / 1000).toString() +
            "/" +
            green.toString() +
            "/" +
            startingKwh.toString() +
            "/" +
            ticket.car.pMaxAC.toInt().toString() +
            "/" +
            ticket.car.pMaxDC.toInt().toString() +
            "/" +
            date +
            "/" +
            time +
            "/" +
            duration +
            "/" +
            targetMinKwh.toString() +
            "/" +
            ticket.car.kwh.toString() +
            "/" +
            ticket.car.kwh.toString();
    return request;
  }

  Widget ticketOfferCollapsed(finalSoCpercent, chargepoint) {
    return Card(
        shadowColor: Colors.green,
        elevation: 15,
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(
          children: [
            Column(children: [
              Text(chargepoint.address!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Price: " + chargepoint.price! + "€"),
                  Text("Leaving SoC: " +
                      finalSoCpercent.toInt().toString() +
                      "%")
                ],
              ),
            ]),
          ],
        ));
  }

  Widget ticketOfferExpanded(
      finalSoCpercent, JsonColumnModel chargepoint, DateTime datetime) {
    final List<ChartElement> data = [];

    String? unifiedState = chargepoint.chargingState!;
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
              time: datetime.add(Duration(minutes: i * 15)),
              barColor: charts.ColorUtil.fromDartColor(chargecolor),
              chargePercent: int.parse(chargepointValues[i])));
    }

    return BlocBuilder<ValidTicketBloc, ValidTicketState>(
        builder: (context, state) {
      return Card(
        shadowColor: Colors.green,
        elevation: 15,
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Column(children: [
          Text(chargepoint.address!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Price: " + chargepoint.price! + "€"),
              Text("Leaving SoC: " + finalSoCpercent.toInt().toString() + "%")
            ],
          ),
          SizedBox(
            height: 330,
            child: ChargeChart(
              data: data,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                String day, month, hour, minute;
                month = datetime.month.toString().length == 1
                    ? "0" + datetime.month.toString()
                    : datetime.month.toString();
                day = datetime.day.toString().length == 1
                    ? "0" + datetime.day.toString()
                    : datetime.day.toString();
                hour = datetime.hour.toString().length == 1
                    ? "0" + datetime.hour.toString()
                    : datetime.hour.toString();
                minute = datetime.minute.toString().length == 1
                    ? "0" + datetime.minute.toString()
                    : datetime.minute.toString();
                String date =
                    datetime.year.toString() + "-" + month + "-" + day;
                String time = hour + ":" + minute;
                int duration =
                    chargepoint.chargingState!.split("T").length * 15;
                http.Response response =
                    await confirmBooking(date, time, duration, chargepoint.id);
                if (response.statusCode == 200) {
                  context
                      .read<ValidTicketBloc>()
                      .add(AddTicket(chargepoint, datetime));
                  context.read<TicketsBloc>().add(const RestoreTicket());
                  showDialog(
                      context: context,
                      builder: (context) => Center(
                              child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Dialog(
                                child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  child: Text(
                                    "Your booking request is accepted. You'll find your ticket resume in the ticket page.",
                                    textScaleFactor: 1.3,
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Ok")),
                              ],
                            )),
                          )));
                }
              },
              child: const Text('Send request')),
        ]),
      );
    });
  }

  Future<http.Response> confirmBooking(date, hour, duration, id) async {
    String request =
        'http://192.168.1.132:8888/green_cars-1.0-SNAPSHOT/ws/bookColumn/' +
            date +
            '/' +
            hour +
            '/' +
            duration.toString() +
            '/' +
            id;
    return http.get(
      Uri.parse(
        (request),
      ),
    );
  }
}
