import 'package:green_cars/data/models/columns.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:uuid/uuid.dart';

class TicketRepository {
  final uuid = const Uuid();
  List<BookedTicket> ticketList = [];

  List<BookedTicket> addTicket(JsonColumnModel column, DateTime date) {
    final BookedTicket e = BookedTicket(
      id: uuid.v4(),
      address: column.address!,
      date: date.toString(),
      leavingSoC: column.finalSoC!.toString(),
      price: column.price.toString(),
      chargingState: column.chargingState!,
    );
    ticketList.add(e);
    return ticketList;
  }

  List<BookedTicket> removeTicket(String id) {
    ticketList.removeWhere((element) => element.id == id);
    return ticketList;
  }
}
