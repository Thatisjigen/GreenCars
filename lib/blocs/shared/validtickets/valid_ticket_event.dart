part of 'valid_ticket_bloc.dart';

abstract class ValidTicketEvent extends Equatable {
  const ValidTicketEvent();

  @override
  List<Object> get props => [];
}

class AddTicket extends ValidTicketEvent {
  final JsonColumnModel column;
  final DateTime date;
  const AddTicket(
    this.column,
    this.date,
  );

  @override
  List<Object> get props => [column, date];
}

class RemoveTickets extends ValidTicketEvent {
  final String id;

  const RemoveTickets(this.id);

  @override
  List<Object> get props => [id];
}
