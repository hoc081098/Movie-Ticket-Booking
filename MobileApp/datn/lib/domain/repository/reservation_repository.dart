import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

import '../model/product.dart';
import '../model/promotion.dart';
import '../model/reservation.dart';

abstract class ReservationRepository {
  Stream<BuiltMap<String, Reservation>> watchReservedTicket(String showTimeId);

  Stream<Reservation> createReservation({
    @required String showTimeId,
    @required String phoneNumber,
    @required String email,
    @required BuiltList<Tuple2<Product, int>> products,
    @required int originalPrice,
    @required String payCardId,
    @required BuiltList<String> ticketIds,
    @required Promotion promotion,
  });
}
