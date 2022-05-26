part of 'valid_ticket_bloc.dart';

abstract class ValidTicketState extends Equatable {
  const ValidTicketState();

  @override
  List<Object> get props => [];

  Map<String, dynamic>? toJson() {
    return null;
  }
}

class TicketsLoading extends ValidTicketState {}

class TicketsLoaded extends ValidTicketState {
  final List<BookedTicket> listOfTicket;

  const TicketsLoaded(this.listOfTicket);

  @override
  List<Object> get props => [listOfTicket];

  @override
  Map<String, dynamic> toJson() {
    return {'Tickets': listOfTicket};
  }
}
