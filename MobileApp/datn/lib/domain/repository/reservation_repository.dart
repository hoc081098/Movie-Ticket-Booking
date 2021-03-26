import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:tuple/tuple.dart';

import '../model/product.dart';
import '../model/promotion.dart';
import '../model/reservation.dart';

abstract class ReservationRepository {
  Stream<BuiltMap<String, Reservation>> watchReservedTicket(String showTimeId);

  Stream<Reservation> createReservation({
    required String showTimeId,
    required String phoneNumber,
    required String email,
    required BuiltList<Tuple2<Product, int>> products,
    required String payCardId,
    required BuiltList<String> ticketIds,
    required Promotion? promotion,
  });

  Stream<BuiltList<Reservation>> getReservation({
    required int page,
    required int perPage,
  });

  Stream<Reservation> getReservationById(String id);

  Stream<Uint8List> getQrCode(String id);
}
