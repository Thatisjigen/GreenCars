import 'package:green_cars/data/models/columns.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:uuid/uuid.dart';

class TicketRepository {
  final uuid = const Uuid();
  List<BookedTicket> ticketList = [];

  List<BookedTicket> addTicket(JsonColumnModel column, DateTime date) {
    final BookedTicket e = BookedTicket(
      id: uuid.v4(),
      column: column,
      date: date.toString(),
    );
    ticketList.add(e);
    return ticketList;
  }

  List<BookedTicket> removeTicket(String id) {
    ticketList.removeWhere((element) => element.id == id);
    return ticketList;
  }
}
