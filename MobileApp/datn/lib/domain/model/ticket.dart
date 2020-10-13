import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

import 'reservation.dart';
import 'seat.dart';

part 'ticket.g.dart';

abstract class Ticket implements Built<Ticket, TicketBuilder> {
  String get id;

  bool get is_active;

  int get price;

  @nullable
  String get reservationId;

  Seat get seat;

  String get show_time;

  DateTime get createdAt;

  DateTime get updatedAt;

  @nullable
  Reservation get reservation;

  Ticket._();

  factory Ticket([void Function(TicketBuilder) updates]) = _$Ticket;

  factory Ticket.from({
    @required String id,
    @required bool is_active,
    @required int price,
    @required String reservationId,
    @required Seat seat,
    @required String show_time,
    @required DateTime createdAt,
    @required DateTime updatedAt,
    @required Reservation reservation,
  }) = _$Ticket._;
}
