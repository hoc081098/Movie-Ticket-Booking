import 'dart:io';

import '../../domain/model/exception.dart';
import '../../domain/model/movie.dart';
import '../../domain/repository/movie_repository.dart';
import '../mappers.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/error_response.dart';
import '../remote/response/movie_response.dart';

class MovieRepositoryImpl implements MovieRepository {
  final AuthClient _authClient;

  MovieRepositoryImpl(this._authClient);

  @override
  Future<List<Movie>> getListMovie(int page, int perPage) async {
    try {
      final usersRes = await _authClient.getBody(buildUrl(
          'admin_movies/', {'page': '$page', 'per_page': '$perPage'})) as List;
      return usersRes
          .map((json) => movieRemoteToDomain(MovieResponse.fromJson(json)))
          .toList();
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedManagerUserException();
      }
      rethrow;
    }
  }
}
