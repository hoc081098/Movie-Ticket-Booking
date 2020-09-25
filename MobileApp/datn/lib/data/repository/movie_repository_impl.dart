import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

import '../../domain/model/location.dart';
import '../../domain/model/movie.dart';
import '../../domain/model/theatre_and_show_times.dart';
import '../../domain/repository/movie_repository.dart';
import '../../utils/type_defs.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/movie_response.dart';
import '../remote/response/show_time_and_theatre_response.dart';
import '../serializers.dart';

class MovieRepositoryImpl implements MovieRepository {
  final AuthClient _authClient;

  final Function1<MovieResponse, Movie> _movieResponseToMovie;
  final Function1<BuiltList<ShowTimeAndTheatreResponse>,
          BuiltMap<DateTime, BuiltList<TheatreAndShowTimes>>>
      _showTimeAndTheatreResponsesToTheatreAndShowTimes;

  MovieRepositoryImpl(
    this._authClient,
    this._movieResponseToMovie,
    this._showTimeAndTheatreResponsesToTheatreAndShowTimes,
  );

  @override
  Stream<BuiltList<Movie>> getNowPlayingMovies({
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

    final response = serializers.deserialize(
      json,
      specifiedType: builtListMovieResponse,
    ) as BuiltList<MovieResponse>;

    yield response.map(_movieResponseToMovie).toBuiltList();
  }

  @override
  Stream<BuiltList<Movie>> getComingSoonMovies({
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

    final response = serializers.deserialize(
      json,
      specifiedType: builtListMovieResponse,
    ) as BuiltList<MovieResponse>;

    yield response.map(_movieResponseToMovie).toBuiltList();
  }

  @override
  Stream<BuiltMap<DateTime, BuiltList<TheatreAndShowTimes>>> getShowTimes({
    String movieId,
    Location location,
  }) async* {
    ArgumentError.checkNotNull(movieId, 'movieId');

    final json = await _authClient.getBody(
      buildUrl(
        '/show-times/movies/$movieId',
        {
          'lat': location?.latitude?.toString(),
          'lng': location?.longitude?.toString(),
        },
      ),
    );

    final response = serializers.deserialize(
      json,
      specifiedType: builtListShowTimeAndTheatreResponse,
    ) as BuiltList<ShowTimeAndTheatreResponse>;

    yield _showTimeAndTheatreResponsesToTheatreAndShowTimes(response);
  }
}
