
import '../model/movie.dart';

abstract class MovieRepository {

  Future<List<Movie>> getListMovie(int page, int perPage);
}
