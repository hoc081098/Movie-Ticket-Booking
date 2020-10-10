abstract class FavoritesRepository {
  Stream<bool> checkFavorite(String movieId);

  Stream<void> toggleFavorite(String movieId);
}
