import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ChartElement {
  final DateTime time;
  final int chargePercent;
  final charts.Color barColor;

  ChartElement(
      {required this.time,
      required this.chargePercent,
      required this.barColor});
}

class ChargeChart extends StatelessWidget {
  final List<ChartElement> data;

  // ignore: prefer_const_constructors_in_immutables
  ChargeChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartElement, DateTime>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (ChartElement series, _) => series.time,
          measureFn: (ChartElement series, _) => series.chargePercent,
          colorFn: (ChartElement series, _) => series.barColor)
    ];

    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Text(
                "Charge state:",
              ),
              Expanded(
                child: charts.TimeSeriesChart(
                  series,
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
