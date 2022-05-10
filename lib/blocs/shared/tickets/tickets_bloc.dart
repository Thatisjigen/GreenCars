import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:green_cars/data/models/tickets.dart';

part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final Ticket ticket;
  TicketsBloc(this.ticket) : super(TicketsInitial(ticket)) {
      on<UpdateTicket>((event, emit) async {
        emit(TicketRefreshing(ticket));
        ticket.UpdateTicket(event.value, event.what);
        emit(TicketsUpdated(ticket));
      });
  }
}
