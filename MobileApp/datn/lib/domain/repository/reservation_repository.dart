import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

import '../model/product.dart';

abstract class ReservationRepository {
  Stream<BuiltList<String>> watchReservedTicket(String showTimeId);

  Stream<void> createReservation({
    @required String showTimeId,
    @required String phoneNumber,
    @required String email,
    @required BuiltList<Tuple2<Product, int>> products,
    @required int originalPrice,
    @required String payCardId,
    @required BuiltList<String> ticketIds,
  });
}
