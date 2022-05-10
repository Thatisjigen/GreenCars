
import 'package:green_cars/data/models/tickets.dart';
import 'package:uuid/uuid.dart';

import '../../models/car.dart';

class ValidTickets {
  final uuid = const Uuid();
  List<BookedTicket> ticketList = [];

  List<BookedTicket> addTicket(String date, double lat, double lon) {
    final ticket = BookedTicket(id: uuid.v4(), date: date, lat: lat, lon: lon);
    ticketList.add(ticket);
    return ticketList;
  }

  List<BookedTicket> removeTicket(String id) {
    ticketList.removeWhere((element) => element.id == id);
    return ticketList;
  }

}
