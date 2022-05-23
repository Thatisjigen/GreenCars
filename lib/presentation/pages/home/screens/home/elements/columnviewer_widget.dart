import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/data/models/columns.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:green_cars/presentation/pages/home/screens/home/elements/maps/maps.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AvailableColumnDialog extends StatelessWidget {
  const AvailableColumnDialog({
    Key? key,
  }) : super(key: key);

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
                  padding: EdgeInsets.only(top: 10),
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

  Widget columnItem({required JsonColumnModel chargepoint, required ticket}) {
    double finalSoCpercent;
    if (ticket.car.pMaxDC > 0) {
      finalSoCpercent = (chargepoint.finalSoC! * 100) / ticket.car.pMaxDC;
    } else {
      finalSoCpercent = (chargepoint.finalSoC! * 100) / ticket.car.pMaxAC;
    }
    LatLng target =
        LatLng(double.parse(chargepoint.lat!), double.parse(chargepoint.lon!));
    MapsScreenState.addMarker(target, chargepoint.id!);
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
            ElevatedButton(
                onPressed: () => {},
                child: const Text(
                    "Book the column.")) //call the second webservice, save data in hydrated bloc.
          ],
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

    return 'http://192.168.1.132:8888/green_cars-1.0-SNAPSHOT/ws/searchColumn/' +
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
        ticket.car.kwh.toString(); // todo: assign all parameters :)
  }
}
