import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../domain/repository/favorites_repository.dart';
import '../../utils/streams.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/favorite_response.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final AuthClient _authClient;
  final _changes = PublishSubject<Tuple2<String, bool>>(sync: true);

  FavoritesRepositoryImpl(this._authClient);

  @override
  Stream<bool> checkFavorite(String movieId) {
    final change$ = _changes
        .mapNotNull((tuple) => tuple.item1 == movieId ? tuple.item2 : null);

    return Rx.defer(() =>
            _authClient.getBody(buildUrl('/favorites/${movieId}')).asStream())
        .map((json) => FavoriteResponse.fromJson(json))
        .map((res) => res.is_favorite)
        .concatWith([change$]);
  }

  @override
  Stream<void> toggleFavorite(String movieId) {
    return Rx.defer(() => _authClient.postBody(buildUrl('/favorites'),
            body: {'movie_id': movieId}).asStream())
        .map((json) => FavoriteResponse.fromJson(json))
        .map((res) => Tuple2(movieId, res.is_favorite))
        .doOnData(_changes.add);
  }
}
