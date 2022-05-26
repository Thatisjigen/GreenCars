import 'package:equatable/equatable.dart';
import 'package:green_cars/data/models/columns.dart';
import 'package:green_cars/data/models/tickets.dart';
import 'package:green_cars/data/repository/tickets/validtickets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'valid_ticket_event.dart';
part 'valid_ticket_state.dart';

class ValidTicketBloc extends HydratedBloc<ValidTicketEvent, ValidTicketState> {
  final TicketRepository ticketsRepository;

  ValidTicketBloc(this.ticketsRepository)
      : super(TicketsLoaded(ticketsRepository.ticketList)) {
    on<AddTicket>((event, emit) async {
      emit(TicketsLoading());
      final updatedTicketList =
          ticketsRepository.addTicket(event.column, event.date);
      emit(TicketsLoaded(updatedTicketList));
    });
    on<RemoveTickets>((event, emit) {
      emit(TicketsLoading());
      final updatedTicketsList = ticketsRepository.removeTicket(event.id);
      emit(TicketsLoaded(updatedTicketsList));
    });
  }

  @override
  ValidTicketState? fromJson(Map<String, dynamic> json) {
    try {
      final list = (json['Tickets'] as List)
          .map((e) => BookedTicket.fromJson(e as Map<String, dynamic>))
          .toList();
      ticketsRepository.ticketList = list;
      return TicketsLoaded(list);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(ValidTicketState state) {
    if (state is TicketsLoaded) {
      return state.toJson();
    } else {
      return null;
    }
  }
}
