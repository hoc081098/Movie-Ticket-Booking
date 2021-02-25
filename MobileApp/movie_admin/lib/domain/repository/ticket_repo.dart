import 'package:built_collection/built_collection.dart';

import '../model/reservation.dart';
import '../model/seat.dart';
import '../model/ticket.dart';

abstract class TicketRepository {
  Stream<BuiltList<Ticket>> getTicketsByShowTimeId(String id);

  Stream<BuiltList<Seat>> getSeatsByTheatreId(String id);

  Stream<BuiltList<Reservation>> getReservationsByShowTimeId(String id);
}
