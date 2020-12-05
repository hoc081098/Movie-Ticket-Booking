import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'movie.dart';
import 'show_time.dart';

part 'movie_and_showtimes.g.dart';

abstract class MovieAndShowTimes
    implements Built<MovieAndShowTimes, MovieAndShowTimesBuilder> {
  Movie get movie;

  BuiltList<ShowTime> get showTimes;

  MovieAndShowTimes._();

  factory MovieAndShowTimes([void Function(MovieAndShowTimesBuilder) updates]) =
      _$MovieAndShowTimes;
}
