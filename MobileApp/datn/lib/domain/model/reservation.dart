import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'product.dart';
import 'promotion.dart';
import 'show_time.dart';
import 'ticket.dart';
import 'user.dart';

part 'reservation.g.dart';

abstract class ProductAndQuantity
    implements Built<ProductAndQuantity, ProductAndQuantityBuilder> {
  String get id;

  Product? get product;

  int get quantity;

  ProductAndQuantity._();

  factory ProductAndQuantity(
          [void Function(ProductAndQuantityBuilder) updates]) =
      _$ProductAndQuantity;

  factory ProductAndQuantity.from({
    required String id,
    required int quantity,
    required Product? product,
  }) = _$ProductAndQuantity._;
}

abstract class Reservation implements Built<Reservation, ReservationBuilder> {
  String get id;

  DateTime get createdAt;

  String get email;

  bool get isActive;

  int get originalPrice;

  String get paymentIntentId;

  String get phoneNumber;

  BuiltList<ProductAndQuantity> get productIdWithCounts;

  String get showTimeId;

  ShowTime? get showTime;

  int get totalPrice;

  DateTime get updatedAt;

  User? get user;

  BuiltList<Ticket>? get tickets;

  String? get promotionId;

  Promotion? get promotion;

  Reservation._();

  factory Reservation([void Function(ReservationBuilder) updates]) =
      _$Reservation;
}
