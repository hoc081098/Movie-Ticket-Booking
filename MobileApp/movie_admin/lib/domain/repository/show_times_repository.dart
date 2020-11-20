import 'dart:async';

import 'package:movie_admin/domain/model/show_time.dart';

abstract class ShowTimesRepository {
  Future<List<ShowTime>> getShowTimesByTheatreId(String id, int page, int perPage);
}

