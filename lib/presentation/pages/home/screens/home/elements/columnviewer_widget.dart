import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';
import 'package:green_cars/data/models/columns.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AvailableColumnDialog extends StatelessWidget {
  const AvailableColumnDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsBloc, TicketsState>(builder: (context, state) {
      return Dialog(
        elevation: 10,
        insetPadding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            columnsListBuilder(context),
          ],
        ),
      );
    });
  }

  Future<http.Response> fetchPhotos(http.Client client) async {
    return client.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
  }

  List<JsonColumnModel> parseColumns(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<JsonColumnModel>((json) => JsonColumnModel.fromJson(json))
        .toList();
  }

  Future<List<JsonColumnModel>> fetchChargingColumns(http.Client client) async {
    final response = await client.get(Uri.parse(
        'http://192.168.1.132:8888/green_cars-1.0-SNAPSHOT/ws/searchColumn/14.324226/41.072692/2/0/1/1/1/2022-11-11/11:30/90/10/10'));
    // Use the compute function to run parsePhotos in a separate isolate.
    return parseColumns(response.body);
  }

  Widget columnsListBuilder(BuildContext context) {
    return FutureBuilder<List<JsonColumnModel>>(
      future: fetchChargingColumns(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('No available columns'),
          );
        } else if (snapshot.hasData) {
          return _columnListView(context, list: snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _columnListView(BuildContext context,
      {required List<JsonColumnModel> list}) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return columnItem(chargepoint: list[index]);
        });
  }

  Widget columnItem({required JsonColumnModel chargepoint}) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        child: Row(
          children: [
            Text(chargepoint.address!),
            Text(chargepoint.id!),
          ],
        ));
  }
}
