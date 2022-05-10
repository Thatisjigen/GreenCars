part of 'tickets_bloc.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();
}

// ignore: must_be_immutable
class UpdateTicket extends TicketsEvent {
  final int what;
  // ignore: prefer_typing_uninitialized_variables
  var value;

  UpdateTicket(this.value, this.what);

  @override
  List<Object> get props => [value];
}
