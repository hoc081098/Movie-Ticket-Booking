import 'dart:async';

import '../model/show_time.dart';

abstract class ShowTimesRepository {
  Future<List<ShowTime>> getShowTimesByTheatreId(
      String id, int page, int perPage);
}
