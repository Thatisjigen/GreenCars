import 'package:green_cars/data/models/tickets.dart';
import 'package:uuid/uuid.dart';

class ValidTickets {
  final uuid = const Uuid();
  List<BookedTicket> ticketList = [];

  List<BookedTicket> addTicket(
      String date, double lat, double lon, int duration) {
    final ticket = BookedTicket(
        id: uuid.v4(), date: date, lat: lat, lon: lon, duration: duration);
    ticketList.add(ticket);
    return ticketList;
  }

  List<BookedTicket> removeTicket(String id) {
    ticketList.removeWhere((element) => element.id == id);
    return ticketList;
  }
}
