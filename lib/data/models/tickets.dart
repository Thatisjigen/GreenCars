import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_cars/data/models/car.dart';

class Ticket {
  int percentage;
  Car car;
  int maxMeters;
  bool green;
  LatLng latlon;
  int targetPercentage;
  int durationMinutes;
  // ignore: prefer_typing_uninitialized_variables
  DateTime date;

  Ticket._privateConstructor(
      {required this.percentage,
      required this.car,
      required this.maxMeters,
      required this.green,
      required this.latlon,
      required this.date,
      required this.durationMinutes,
      required this.targetPercentage});

  static final Ticket _instance = Ticket._privateConstructor(
    //make it a singleton using a dumb instance with non valid values
    percentage: 0,
    car: Car(
        id: "-1",
        name: "default",
        kwh: -1,
        pMaxAC: -1,
        pMaxDC: -1,
        efficiency: -1),
    maxMeters: 0,
    green: false,
    latlon: const LatLng(-1, -1),
    date: DateTime.now().subtract(const Duration(days: 10)),
    durationMinutes: 15,
    targetPercentage: 100,
  );

  factory Ticket() {
    return _instance;
  }

  Ticket.fromJson(Map<String, dynamic> json)
      : percentage = json['percentage'],
        car = json['car'],
        maxMeters = json['maxMeter'],
        green = json['green'],
        latlon = json['latlon'],
        date = json['date'],
        durationMinutes = json['durationMinutes'],
        targetPercentage = json['targetPercentage'];

  Map<String, dynamic> toJson() => {
        'percentage': percentage,
        'car': car,
        'maxMeters': maxMeters,
        'green': green,
        'latlon': latlon,
        'durationMinutes': durationMinutes,
        'targetPercentage': targetPercentage,
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
        latlon = value;
        break;
      case (5):
        targetPercentage = value;
        break;
      case (7):
        date = value;
        break;
      case (8):
        durationMinutes = value;
        break;
      default:
        return;
    }
  }
}

class BookedTicket {
  final String date;
  String id;
  String address;
  String leavingSoC;
  String price;
  String chargingState;

  BookedTicket({
    required this.date,
    required this.address,
    required this.id,
    required this.leavingSoC,
    required this.price,
    required this.chargingState,
  });

  BookedTicket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = json['date'],
        address = json['address'],
        leavingSoC = json['leavingSoC'],
        price = json['price'],
        chargingState = json['chargingState'];

  String get ticket => address;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'address': address,
        'leavingSoC': leavingSoC,
        'price': price,
        'chargingState': chargingState,
      };
}
