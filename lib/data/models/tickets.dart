import 'package:green_cars/data/models/car.dart';

class Ticket {
  int percentage;
  Car car;
  int maxMeters;
  bool green;
  double lat, lon;
  // ignore: prefer_typing_uninitialized_variables
  var date;

  Ticket._privateConstructor({
    required this.percentage,
    required this.car,
    required this.maxMeters,
    required this.green,
    required this.lat,
    required this.lon,
    required this.date,
  });

  static final Ticket _instance = Ticket._privateConstructor(
    percentage: 0,
    car: Car(id: "-1", name: "default", kwh: 100),
    maxMeters: 0,
    green: false,
    lat: -1,
    lon: -1,
    date: "20/12/20 14:30",
  );

  factory Ticket() {
    return _instance;
  }

  Ticket.fromJson(Map<String, dynamic> json)
      : percentage = json['percentage'],
        car = json['car'],
        maxMeters = json['maxMeter'],
        green = json['green'],
        lat = json['lat'],
        lon = json['lon'];

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'car': car,
        'maxMeters': maxMeters,
        'green': green,
        'lat': lat,
        'lon': lon,
      };

  updateTicket(var value, int what) {
    switch (what) {
      case (0):
        percentage = value;
        break;
      case (1):
        car = value;
        break;
      case (2):
        maxMeters = value;
        break;
      case (3):
        green = value;
        break;
      case (4):
        lat = value;
        break;
      case (5):
        lon = value;
        break;
      default:
        return;
    }
  }
}

class BookedTicket {
  final double lat, lon;
  final String date;
  final String id;
  final int duration;

  BookedTicket({
    required this.id,
    required this.lat,
    required this.lon,
    required this.date,
    required this.duration,
  });

  BookedTicket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lat = json['lat'],
        lon = json['lon'],
        date = json['date'],
        duration = json['duration'];

  String get bookedtickets => date;

  Map<String, dynamic> toJson() => {
        'id': id,
        'lat': lat,
        'lon': lon,
        'date': date,
        'duration': duration,
      };
}
