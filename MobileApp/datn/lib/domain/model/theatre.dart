import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'location.dart';

part 'theatre.g.dart';

abstract class Theatre implements Built<Theatre, TheatreBuilder> {
  String get id;

  Location get location;

  bool get is_active;

  BuiltList<String> get rooms;

  String get name;

  String get address;

  String get phone_number;

  String get description;

  String? get email;

  String get opening_hours;

  String get room_summary;

  DateTime get createdAt;

  DateTime get updatedAt;

  double? get distance;

  String get thumbnail;

  String get cover;

  Theatre._();

  factory Theatre([void Function(TheatreBuilder) updates]) = _$Theatre;
}
