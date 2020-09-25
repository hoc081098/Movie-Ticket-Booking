import 'package:built_value/built_value.dart';

part 'show_time.g.dart';

abstract class ShowTime implements Built<ShowTime, ShowTimeBuilder> {
  String get id;

  bool get is_active;

  String get movie;

  String get theatre;

  String get room;

  DateTime get end_time;

  DateTime get start_time;

  DateTime get createdAt;

  DateTime get updatedAt;

  ShowTime._();

  factory ShowTime([void Function(ShowTimeBuilder) updates]) = _$ShowTime;
}
