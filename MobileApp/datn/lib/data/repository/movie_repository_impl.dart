import 'package:built_collection/built_collection.dart';
import 'package:datn/data/remote/response/movie_and_show_time_response.dart';
import 'package:datn/domain/model/movie_and_showtimes.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/location.dart';
import '../../domain/model/movie.dart';
import '../../domain/model/theatre_and_show_times.dart';
import '../../domain/repository/movie_repository.dart';
import '../../utils/type_defs.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/movie_detail_response.dart';
import '../remote/response/movie_response.dart';
import '../remote/response/show_time_and_theatre_response.dart';
import '../serializers.dart';

class MovieRepositoryImpl implements MovieRepository {
  final AuthClient _authClient;

  final Function1<MovieResponse, Movie> _movieResponseToMovie;
  final Function1<BuiltList<ShowTimeAndTheatreResponse>,
          BuiltMap<DateTime, BuiltList<TheatreAndShowTimes>>>
      _showTimeAndTheatreResponsesToTheatreAndShowTimes;
  final Function1<MovieDetailResponse, Movie> _movieDetailResponseToMovie;

  final Function1<BuiltList<MovieAndShowTimeResponse>,
          BuiltMap<DateTime, BuiltList<MovieAndShowTimes>>>
      _movieAndShowTimeResponsesToMovieAndShowTimes;

  MovieRepositoryImpl(
    this._authClient,
    this._movieResponseToMovie,
    this._showTimeAndTheatreResponsesToTheatreAndShowTimes,
    this._movieDetailResponseToMovie,
    this._movieAndShowTimeResponsesToMovieAndShowTimes,
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
          if (location != null) ...{
            'lat': location.latitude.toString(),
            'lng': location.longitude.toString(),
          },
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
        location != null
            ? {
                'lat': location.latitude.toString(),
                'lng': location.longitude.toString(),
              }
            : null,
      ),
    );

    final response = serializers.deserialize(
      json,
      specifiedType: builtListShowTimeAndTheatreResponse,
    ) as BuiltList<ShowTimeAndTheatreResponse>;

    yield _showTimeAndTheatreResponsesToTheatreAndShowTimes(response);
  }

  @override
  Stream<Movie> getMovieDetail(String movieId) async* {
    ArgumentError.checkNotNull(movieId, 'movieId');

    final json = await _authClient.getBody(buildUrl('/movies/$movieId'));
    yield _movieDetailResponseToMovie(MovieDetailResponse.fromJson(json));
  }

  @override
  Stream<BuiltList<Movie>> getRecommendedMovies(Location location) =>
      Rx.fromCallable(() => _authClient
          .getBody(
            buildUrl(
              '/neo4j',
              location != null
                  ? {
                      'lat': location.latitude.toString(),
                      'lng': location.longitude.toString(),
                    }
                  : null,
            ),
          )
          .then(mapResult));

  @override
  Stream<BuiltList<Movie>> getMostFavorite({int page, int perPage}) {
    if (page == null) return Stream.error(ArgumentError.notNull('page'));
    if (perPage == null) return Stream.error(ArgumentError.notNull('perPage'));

    return Rx.fromCallable(() => _authClient
        .getBody(
          buildUrl(
            '/movies/most-favorite',
            {
              'page': page.toString(),
              'per_page': perPage.toString(),
            },
          ),
        )
        .then(mapResult));
  }

  @override
  Stream<BuiltList<Movie>> getMostRate({int page, int perPage}) {
    if (page == null) return Stream.error(ArgumentError.notNull('page'));
    if (perPage == null) return Stream.error(ArgumentError.notNull('perPage'));

    return Rx.fromCallable(() => _authClient
        .getBody(
          buildUrl(
            '/movies/most-rate',
            {
              'page': page.toString(),
              'per_page': perPage.toString(),
            },
          ),
        )
        .then(mapResult));
  }

  BuiltList<Movie> mapResult(dynamic json) {
    final response = serializers.deserialize(
      json,
      specifiedType: builtListMovieResponse,
    ) as BuiltList<MovieResponse>;

    return response.map(_movieResponseToMovie).toBuiltList();
  }

  @override
  Stream<BuiltMap<DateTime, BuiltList<MovieAndShowTimes>>>
      getShowTimesByTheatreId(String theatreId) {
    if (theatreId == null) {
      return Stream.error(ArgumentError.notNull('theatreId'));
    }

    final mapResult = (Object json) {
      final response = serializers.deserialize(
        json,
        specifiedType: builtListMovieAndShowTimeResponse,
      ) as BuiltList<MovieAndShowTimeResponse>;
      return _movieAndShowTimeResponsesToMovieAndShowTimes(response);
    };

    return Rx.fromCallable(() => _authClient
        .getBody(buildUrl('/show-times/theatres/${theatreId}'))
        .then(mapResult));
  }
}
