import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

import '../model/show_time.dart';

abstract class ShowTimesRepository {
  Future<List<ShowTime>> getShowTimesByTheatreId(
      String id, int page, int perPage);

  Future<void> addShowTime({
    @required String movieId,
    @required String theatreId,
    @required DateTime startTime,
    @required List<Tuple2<String, int>> tickets,
  });

  Future<List<Tuple2<DateTime, DateTime>>> availablePeriods(
    String theatre_id,
    DateTime day,
  );

  Future<BuiltMap<String, int>> report(String theatre_id, String MMyyyy);
}
