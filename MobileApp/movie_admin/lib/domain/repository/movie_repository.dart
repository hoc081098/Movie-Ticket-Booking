import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import '../model/location.dart';
import '../model/movie.dart';

abstract class MovieRepository {
  Stream<List<Movie>> getNowPlayingMovies({
    Location location,
    @required int page,
    @required int perPage,
  });

  Stream<List<Movie>> getComingSoonMovies({
    @required int page,
    @required int perPage,
  });

  Stream<Movie> getMovieDetail(String movieId);
}
