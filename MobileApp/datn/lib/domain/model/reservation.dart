import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:tuple/tuple.dart';

import 'show_time.dart';
import 'user.dart';

part 'reservation.g.dart';

abstract class Reservation implements Built<Reservation, ReservationBuilder> {
  String get id;

  DateTime get createdAt;

  String get email;

  bool get isActive;

  int get originalPrice;

  String get paymentIntentId;

  String get phoneNumber;

  BuiltList<Tuple2<String, int>> get productIdWithCounts;

  String get showTimeId;

  @nullable
  ShowTime get showTime;

  int get totalPrice;

  DateTime get updatedAt;

  @nullable
  User get user;

  Reservation._();

  factory Reservation([void Function(ReservationBuilder) updates]) =
      _$Reservation;
}
