import 'package:built_value/built_value.dart';
import 'movie.dart';
import 'theatre.dart';

part 'show_time.g.dart';

abstract class ShowTime implements Built<ShowTime, ShowTimeBuilder> {
  String get id;

  bool get is_active;

  String get movieId;

  Movie? get movie;

  String get theatreId;

  Theatre? get theatre;

  String get room;

  DateTime get end_time;

  DateTime get start_time;

  DateTime get createdAt;

  DateTime get updatedAt;

  ShowTime._();

  factory ShowTime([void Function(ShowTimeBuilder) updates]) = _$ShowTime;
}
