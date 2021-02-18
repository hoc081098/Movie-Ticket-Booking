import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'show_time.dart';
import 'theatre.dart';

part 'theatre_and_show_times.g.dart';

abstract class TheatreAndShowTimes
    implements Built<TheatreAndShowTimes, TheatreAndShowTimesBuilder> {
  Theatre get theatre;

  BuiltList<ShowTime> get showTimes;

  TheatreAndShowTimes._();

  factory TheatreAndShowTimes(
          [void Function(TheatreAndShowTimesBuilder) updates]) =
      _$TheatreAndShowTimes;
}
