import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:rxdart/rxdart.dart';

import '../../domain/model/category.dart';
import '../../domain/model/location.dart';
import '../../domain/model/movie.dart';
import '../../domain/model/movie_and_showtimes.dart';
import '../../domain/model/theatre_and_show_times.dart';
import '../../domain/repository/movie_repository.dart';
import '../../utils/utils.dart';
import '../local/search_keyword_source.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/category_response.dart';
import '../remote/response/movie_and_show_time_response.dart';
import '../remote/response/movie_detail_response.dart';
import '../remote/response/movie_response.dart';
import '../remote/response/show_time_and_theatre_response.dart';
import '../serializers.dart';

// TODO: unnecessary_null_comparison
// ignore_for_file: unnecessary_null_comparison

class MovieRepositoryImpl implements MovieRepository {
  final AuthHttpClient _authClient;

  final Function1<MovieResponse, Movie> _movieResponseToMovie;
  final Function1<BuiltList<ShowTimeAndTheatreResponse>,
          BuiltMap<DateTime, BuiltList<TheatreAndShowTimes>>>
      _showTimeAndTheatreResponsesToTheatreAndShowTimes;
  final Function1<MovieDetailResponse, Movie> _movieDetailResponseToMovie;

  final Function1<BuiltList<MovieAndShowTimeResponse>,
          BuiltMap<DateTime, BuiltList<MovieAndShowTimes>>>
      _movieAndShowTimeResponsesToMovieAndShowTimes;

  final Function1<CategoryResponse, Category> _categoryResponseToCategory;

  final SearchKeywordSource _searchKeywordSource;

  MovieRepositoryImpl(
    this._authClient,
    this._movieResponseToMovie,
    this._showTimeAndTheatreResponsesToTheatreAndShowTimes,
    this._movieDetailResponseToMovie,
    this._movieAndShowTimeResponsesToMovieAndShowTimes,
    this._searchKeywordSource,
    this._categoryResponseToCategory,
  );

  @override
  Stream<BuiltList<Movie>> getNowPlayingMovies({
    required Location? location,
    required int page,
    required int perPage,
  }) async* {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(perPage, 'perPage');

    final json = await _authClient.getJson(
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
    required int page,
    required int perPage,
  }) async* {
    ArgumentError.checkNotNull(page, 'page');
    ArgumentError.checkNotNull(perPage, 'perPage');

    final json = await _authClient.getJson(
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
    required String movieId,
    required Location? location,
  }) async* {
    ArgumentError.checkNotNull(movieId, 'movieId');

    final json = await _authClient.getJson(
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

    final json = await _authClient.getJson(buildUrl('/movies/$movieId'));
    yield _movieDetailResponseToMovie(MovieDetailResponse.fromJson(json));
  }

  @override
  Stream<BuiltList<Movie>> getRecommendedMovies(Location? location) =>
      Rx.fromCallable(() => _authClient
          .getJson(
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
  Stream<BuiltList<Movie>> getMostFavorite({
    required int page,
    required int perPage,
  }) {
    if (page == null) return Stream.error(ArgumentError.notNull('page'));
    if (perPage == null) return Stream.error(ArgumentError.notNull('perPage'));

    return Rx.fromCallable(() => _authClient
        .getJson(
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
  Stream<BuiltList<Movie>> getMostRate({
    required int page,
    required int perPage,
  }) {
    if (page == null) return Stream.error(ArgumentError.notNull('page'));
    if (perPage == null) return Stream.error(ArgumentError.notNull('perPage'));

    return Rx.fromCallable(() => _authClient
        .getJson(
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

    final mapResult = (Object? json) {
      final response = serializers.deserialize(
        json,
        specifiedType: builtListMovieAndShowTimeResponse,
      ) as BuiltList<MovieAndShowTimeResponse>;
      return _movieAndShowTimeResponsesToMovieAndShowTimes(response);
    };

    return Rx.fromCallable(() => _authClient
        .getJson(buildUrl('/show-times/theatres/$theatreId'))
        .then(mapResult));
  }

  @override
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
  }) {
    if (query == null) {
      return Stream.error(ArgumentError.notNull('query'));
    }
    if (showtimeStartTime == null) {
      return Stream.error(ArgumentError.notNull('showtimeStartTime'));
    }
    if (showtimeEndTime == null) {
      return Stream.error(ArgumentError.notNull('showtimeEndTime'));
    }
    if (minReleasedDate == null) {
      return Stream.error(ArgumentError.notNull('minReleasedDate'));
    }
    if (maxReleasedDate == null) {
      return Stream.error(ArgumentError.notNull('maxReleasedDate'));
    }
    if (minDuration == null) {
      return Stream.error(ArgumentError.notNull('minDuration'));
    }
    if (maxReleasedDate == null) {
      return Stream.error(ArgumentError.notNull('maxReleasedDate'));
    }
    if (maxReleasedDate == null) {
      return Stream.error(ArgumentError.notNull('maxReleasedDate'));
    }
    if (selectedCategoryIds == null) {
      return Stream.error(ArgumentError.notNull('selectedCategoryIds'));
    }

    return Rx.fromCallable(() => _authClient
        .getJson(
          buildUrl(
            '/neo4j/search-movies',
            {
              'query': query,
              'search_start_time': showtimeStartTime.toUtc().toIso8601String(),
              'search_end_time': showtimeEndTime.toUtc().toIso8601String(),
              'min_released_date': minReleasedDate.toUtc().toIso8601String(),
              'max_released_date': maxReleasedDate.toUtc().toIso8601String(),
              'min_duration': minDuration.toString(),
              'max_duration': maxDuration.toString(),
              'age_type': describeEnum(ageType),
              if (selectedCategoryIds.isNotEmpty)
                'category_ids': selectedCategoryIds.join(','),
              if (location != null) ...{
                'lat': location.latitude.toString(),
                'lng': location.longitude.toString(),
              },
            },
          ),
        )
        .then(mapResult));
  }

  @override
  Future<void> saveSearchQuery(String query) =>
      _searchKeywordSource.saveSearchQuery(query);

  @override
  Future<BuiltList<String>> getQueries() => _searchKeywordSource.getQueries();

  @override
  Stream<BuiltList<Category>> getCategories() {
    final mapResult = (dynamic json) {
      final response = serializers.deserialize(
        json,
        specifiedType: builtListCategoryResponse,
      )! as BuiltList<CategoryResponse>;

      return [for (final r in response) _categoryResponseToCategory(r)].build();
    };
    return Rx.fromCallable(
        () => _authClient.getJson(buildUrl('/categories')).then(mapResult));
  }

  @override
  Stream<BuiltList<Movie>> getRelatedMovies(String movieId) {
    if (movieId == null) {
      return Stream.error(ArgumentError.notNull('movieId'));
    }
    return Rx.fromCallable(
      () => _authClient
          .getJson(buildUrl('/neo4j/related-movies/$movieId'))
          .then(mapResult),
    );
  }
}
