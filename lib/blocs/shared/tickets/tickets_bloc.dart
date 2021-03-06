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
      ticket.updateTicket(event.value, event.what);
      emit(TicketsUpdated(ticket));
    });
    on<RestoreTicket>((event, emit) async {
      emit(TicketRefreshing(ticket));
      Ticket ticketVoid = Ticket();
      emit(TicketsInitial(ticketVoid));
    });
  }
}
