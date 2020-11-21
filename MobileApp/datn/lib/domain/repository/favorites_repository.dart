import 'package:built_collection/built_collection.dart';

import '../model/movie.dart';

abstract class FavoritesRepository {
  Stream<bool> checkFavorite(String movieId);

  Stream<void> toggleFavorite(String movieId);

  Stream<BuiltList<Movie>> favoritesMovie();

  Future<void> refresh();
}
