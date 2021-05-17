import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../domain/model/movie.dart';
import '../../domain/repository/favorites_repository.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/favorite_response.dart';
import '../remote/response/movie_response.dart';
import '../serializers.dart';

abstract class _Change {}

class _Toggled implements _Change {
  final Movie movie;
  final bool favorite;

  _Toggled(this.movie, this.favorite);
}

class _Refreshed implements _Change {
  final BuiltList<Movie> _movies;

  _Refreshed(this._movies);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final AuthHttpClient _authClient;
  final Function1<MovieResponse, Movie> _movieResponseToMovie;
  final _changes = PublishSubject<_Change>(sync: true);

  FavoritesRepositoryImpl(this._authClient, this._movieResponseToMovie);

  @override
  Stream<bool> checkFavorite(String movieId) {
    final change$ = _changes.mapNotNull((change) {
      if (change is _Toggled) {
        return change.movie.id == movieId ? change.favorite : null;
      }
      if (change is _Refreshed) {
        return change._movies.any((m) => m.id == movieId);
      }
      throw StateError('Unknown change $change');
    });

    return Rx.fromCallable(
            () => _authClient.getJson(buildUrl('/favorites/$movieId')))
        .map((json) => FavoriteResponse.fromJson(json))
        .map((res) => res.is_favorite)
        .concatWith([change$]);
  }

  @override
  Stream<void> toggleFavorite(String movieId) {
    return Rx.fromCallable(() => _authClient
            .postJson(buildUrl('/favorites'), body: {'movie_id': movieId}))
        .map((json) => FavoriteResponse.fromJson(json))
        .map(
          (res) => _Toggled(
            _movieResponseToMovie(res.movie),
            res.is_favorite,
          ),
        )
        .doOnData(_changes.add)
        .mapTo<void>(null);
  }

  @override
  Stream<BuiltList<Movie>> favoritesMovie() {
    return Rx.fromCallable(() => _authClient.getJson(buildUrl('/favorites')))
        .map(_jsonToMovies)
        .exhaustMap(
          (initial) => _changes.scan<BuiltList<Movie>>(
            (acc, change, _) {
              if (change is _Toggled) {
                return acc.rebuild((b) {
                  change.favorite
                      ? b.insert(0, change.movie)
                      : b.removeWhere((item) => item.id == change.movie.id);
                });
              }
              if (change is _Refreshed) {
                return change._movies;
              }
              throw StateError('Unknown change $change');
            },
            initial,
          ).startWith(initial),
        );
  }

  @override
  Future<void> refresh() {
    return _authClient
        .getJson(buildUrl('/favorites'))
        .then(_jsonToMovies)
        .then((value) => _Refreshed(value))
        .then(_changes.add)
        .then<void>((value) => null);
  }

  BuiltList<Movie> _jsonToMovies(dynamic json) {
    final responses = serializers.deserialize(
      json,
      specifiedType: builtListMovieResponse,
    ) as BuiltList<MovieResponse>;

    return [for (final res in responses) _movieResponseToMovie(res)].build();
  }
}
