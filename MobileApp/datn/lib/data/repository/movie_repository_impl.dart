import 'package:built_collection/built_collection.dart';
import 'package:datn/data/remote/auth_client.dart';
import 'package:datn/data/remote/base_url.dart';
import 'package:datn/data/remote/response/movie_response.dart';
import 'package:datn/data/serializers.dart';
import 'package:datn/domain/model/location.dart';
import 'package:datn/utils/type_defs.dart';
import 'package:datn/utils/utils.dart';

import '../../domain/model/movie.dart';
import '../../domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final AuthClient _authClient;
  final Function1<MovieResponse, Movie> _movieResponseToMovie;

  MovieRepositoryImpl(this._authClient, this._movieResponseToMovie);

  @override
  Stream<BuiltList<Movie>> getNowPlayingMovies(
    Location location,
    int page,
  ) async* {
    final json = await _authClient.getBody(
      buildUrl(
        '/movies/now-playing',
        {
          'page': page.toString(),
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
}
