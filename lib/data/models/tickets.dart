import 'package:green_cars/blocs/shared/tickets/tickets_bloc.dart';

class Ticket {
  int percentage;
  int kwh;
  int maxMeters;
  bool green;
  double lat, lon;
  var date;

  Ticket._privateConstructor({
    required this.percentage,
    required this.kwh,
    required this.maxMeters,
    required this.green,
    required this.lat,
    required this.lon,
    required this.date,
  });

  static final Ticket _instance = Ticket._privateConstructor(
    percentage: 0,
    kwh: 0,
    maxMeters: 0,
    green: false,
    lat: 41.000,
    lon: 1.000,
    date: "20/12/20 14:30",);

  factory Ticket() {
    return _instance;
  }

  Ticket.fromJson(Map<String, dynamic> json)
      : percentage = json['percentage'],
        kwh = json['kwh'],
        maxMeters = json['maxMeter'],
        green = json['green'],
        lat = json['lat'],
        lon =json['lon'];

  String get ticket => this.ticket;

  Map<String, dynamic> toJson() =>
      {
        'percentage': percentage,
        'kwh': kwh,
        'maxMeters': maxMeters,
        'green': green,
        'lat': lat,
        'lon': lon,
      };

  UpdateTicket(var value, int what) {
    switch (what) {
      case(0):
        percentage = value;
        break;
      case(1):
        kwh = value;
        break;
      case (2):
        maxMeters = value;
        break;
      case(3):
        green = value;
        break;
      case(4):
        lat = value;
        break;
      case(5):
        lon = value;
        break;
      default:
        return;
    }
  }
}


class BookedTicket {
  final double lat,lon;
  final String date;
  final String id;

  BookedTicket({
    required this.id,
    required this.lat,
    required this.lon,
    required this.date,
  });


  BookedTicket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lat = json['lat'],
        lon = json['lon'],
        date = json ['date'];

  String get bookedtickets => this.date;

  Map<String, dynamic> toJson() => {
    'id': id,
    'lat': lat,
    'lon': lon,
    'date' : date,
  };
}