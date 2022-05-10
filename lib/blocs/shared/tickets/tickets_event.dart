part of 'tickets_bloc.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();
}


class UpdateTicket extends TicketsEvent {
  final int what;
  var value ;

  UpdateTicket(this.value, this.what);

  @override
  List<Object> get props => [value];
}
