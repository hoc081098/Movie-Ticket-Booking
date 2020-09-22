import 'package:built_collection/built_collection.dart';
import '../model/location.dart';
import '../model/movie.dart';

abstract class MovieRepository {
  Stream<BuiltList<Movie>> getNowPlayingMovies(Location location, int page);
}
