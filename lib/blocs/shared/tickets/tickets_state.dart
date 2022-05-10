part of 'tickets_bloc.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object> get props => [];

  get ticket => null;
}

class TicketsInitial extends TicketsState {
  @override
  final Ticket ticket;

  const TicketsInitial(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class TicketsUpdated extends TicketsState {
  @override
  final Ticket ticket;

  const TicketsUpdated(this.ticket);

  @override
  List<Object> get props => [ticket];

  Map<String, dynamic> toJson() {
    return {'Ticket': ticket};
  }
}

class TicketRefreshing extends TicketsState {
  @override
  final Ticket ticket;

  const TicketRefreshing(this.ticket);

  @override
  List<Object> get props => [ticket];

  Map<String, dynamic> toJson() {
    return {'Ticket': ticket};
  }
}
