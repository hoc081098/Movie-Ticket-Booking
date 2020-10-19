import 'package:built_collection/src/list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/movie.dart';
import '../../domain/repository/favorites_repository.dart';
import '../../utils/streams.dart';
import '../../utils/type_defs.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/favorite_response.dart';
import '../remote/response/movie_response.dart';
import '../serializers.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final AuthClient _authClient;
  final Function1<MovieResponse, Movie> _movieResponseToMovie;
  final _changes = PublishSubject<Tuple2<Movie, bool>>(sync: true);

  FavoritesRepositoryImpl(this._authClient, this._movieResponseToMovie);

  @override
  Stream<bool> checkFavorite(String movieId) {
    final change$ = _changes
        .mapNotNull((tuple) => tuple.item1.id == movieId ? tuple.item2 : null);

    return Rx.fromCallable(
            () => _authClient.getBody(buildUrl('/favorites/${movieId}')))
        .map((json) => FavoriteResponse.fromJson(json))
        .map((res) => res.is_favorite)
        .concatWith([change$]);
  }

  @override
  Stream<void> toggleFavorite(String movieId) {
    return Rx.fromCallable(() => _authClient
            .postBody(buildUrl('/favorites'), body: {'movie_id': movieId}))
        .map((json) => FavoriteResponse.fromJson(json))
        .map(
          (res) => Tuple2(
            _movieResponseToMovie(res.movie),
            res.is_favorite,
          ),
        )
        .doOnData(_changes.add);
  }

  @override
  Stream<BuiltList<Movie>> favoritesMovie() {
    final jsonToMovies = (dynamic json) {
      final responses = serializers.deserialize(
        json,
        specifiedType: builtListMovieResponse,
      ) as BuiltList<MovieResponse>;

      return [for (final res in responses) _movieResponseToMovie(res)].build();
    };

    return Rx.fromCallable(() => _authClient.getBody(buildUrl('/favorites')))
        .map(jsonToMovies)
        .exhaustMap(
          (initial) => _changes
              .scan<BuiltList<Movie>>(
                (acc, change, _) => acc.rebuild(
                  (b) => change.item2
                      ? b.add(change.item1)
                      : b.removeWhere((item) => item.id == change.item1.id),
                ),
                initial,
              )
              .startWith(initial),
        );
  }
}
