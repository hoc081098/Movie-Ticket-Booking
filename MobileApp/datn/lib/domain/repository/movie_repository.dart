import 'package:built_collection/built_collection.dart';

import '../model/category.dart';
import '../model/location.dart';
import '../model/movie.dart';
import '../model/movie_and_showtimes.dart';
import '../model/theatre_and_show_times.dart';

abstract class MovieRepository {
  Stream<BuiltList<Movie>> getNowPlayingMovies({
    required Location? location,
    required int page,
    required int perPage,
  });

  Stream<BuiltList<Movie>> getComingSoonMovies({
    required int page,
    required int perPage,
  });

  Stream<BuiltList<Movie>> getRecommendedMovies(Location? location);

  Stream<BuiltList<Movie>> getMostFavorite({
    required int page,
    required int perPage,
  });

  Stream<BuiltList<Movie>> getMostRate({
    required int page,
    required int perPage,
  });

  Stream<BuiltMap<DateTime, BuiltList<TheatreAndShowTimes>>> getShowTimes({
    required String movieId,
    required Location? location,
  });

  Stream<Movie> getMovieDetail(String movieId);

  Stream<BuiltList<Movie>> getRelatedMovies(String movieId);

  Stream<BuiltMap<DateTime, BuiltList<MovieAndShowTimes>>>
      getShowTimesByTheatreId(String theatreId);

  Stream<BuiltList<Movie>> search({
    required String query,
    required DateTime showtimeStartTime,
    required DateTime showtimeEndTime,
    required DateTime minReleasedDate,
    required DateTime maxReleasedDate,
    required int minDuration,
    required int maxDuration,
    required AgeType ageType,
    required Location? location,
    required BuiltSet<String> selectedCategoryIds,
  });

  Future<void> saveSearchQuery(String query);

  Future<BuiltList<String>> getQueries();

  Stream<BuiltList<Category>> getCategories();
}
