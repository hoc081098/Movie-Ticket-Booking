import 'package:meta/meta.dart';

import '../../domain/model/location.dart';
import '../../domain/model/movie.dart';
import '../../domain/repository/movie_repository.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/movie_detail_response.dart';
import '../remote/response/movie_response.dart';

class MovieRepositoryImpl implements MovieRepository {
  final AuthClient _authClient;

  final Function1<MovieResponse, Movie> _movieResponseToMovie;
  final Function1<MovieDetailResponse, Movie> _movieDetailResponseToMovie;

  MovieRepositoryImpl(
      this._authClient,
      this._movieResponseToMovie,
      this._movieDetailResponseToMovie,
      );

  @override
  Stream<List<Movie>> getNowPlayingMovies({
    Location location,
    @required int page,
    @required int perPage,
  }) async* {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(perPage, 'perPage');

    final json = await _authClient.getBody(
      buildUrl(
        '/movies/now-playing',
        {
          'page': page.toString(),
          'per_page': perPage.toString(),
          'lat': location?.latitude?.toString(),
          'lng': location?.longitude?.toString(),
        },
      ),
    );

  }

  @override
  Stream<List<Movie>> getComingSoonMovies({
    @required int page,
    @required int perPage,
  }) async* {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(perPage, 'perPage');

    final json = await _authClient.getBody(
      buildUrl(
        '/movies/coming-soon',
        {
          'page': page.toString(),
          'per_page': perPage.toString(),
        },
      ),
    );


  }

  @override
  Stream<Movie> getMovieDetail(String movieId) async* {
    ArgumentError.checkNotNull(movieId, 'movieId');

    final json = await _authClient.getBody(buildUrl('/movies/$movieId'));
    yield _movieDetailResponseToMovie(MovieDetailResponse.fromJson(json));
  }
}