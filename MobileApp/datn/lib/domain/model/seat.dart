import 'package:built_value/built_value.dart';

part 'seat.g.dart';

abstract class SeatCoordinates
    implements Built<SeatCoordinates, SeatCoordinatesBuilder> {
  int get x;

  int get y;

  SeatCoordinates._();

  factory SeatCoordinates([void Function(SeatCoordinatesBuilder) updates]) =
      _$SeatCoordinates;

  factory SeatCoordinates.from({required int x, required int y}) =
      _$SeatCoordinates._;
}

abstract class Seat implements Built<Seat, SeatBuilder> {
  bool get is_active;

  SeatCoordinates get coordinates;

  String get id;

  String get room;

  String get theatre;

  int get column;

  String get row;

  int get count;

  DateTime get createdAt;

  DateTime get updatedAt;

  Seat._();

  factory Seat([void Function(SeatBuilder) updates]) = _$Seat;

  factory Seat.from({
    required bool is_active,
    required SeatCoordinates coordinates,
    required String id,
    required String room,
    required String theatre,
    required int column,
    required String row,
    required int count,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _$Seat._;
}
