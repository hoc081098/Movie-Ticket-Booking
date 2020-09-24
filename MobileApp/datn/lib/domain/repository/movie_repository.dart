import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../model/location.dart';
import '../model/movie.dart';

abstract class MovieRepository {
  Stream<BuiltList<Movie>> getNowPlayingMovies({
    Location location,
    @required int page,
    @required int perPage,
  });

  Stream<BuiltList<Movie>> getComingSoonMovies({
    @required int page,
    @required int perPage,
  });
}
