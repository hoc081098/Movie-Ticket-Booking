import 'package:movie_admin/data/remote/auth_client.dart';
import 'package:movie_admin/data/remote/base_url.dart';
import 'package:movie_admin/data/remote/response/show_time_response.dart';
import 'package:movie_admin/domain/model/show_time.dart';
import 'package:movie_admin/domain/repository/show_times_repository.dart';

import '../mappers.dart' as mappers;

class ShowTimesRepositoryImpl implements ShowTimesRepository {
  final AuthClient _authClient;

  ShowTimesRepositoryImpl(this._authClient);

  @override
  Future<List<ShowTime>> getShowTimesByTheatreId(
      String id, int page, int perPage) {
    return _authClient
        .getBody(
          buildUrl(
            '/admin-show-times/theatres/$id',
            {
              'page': page.toString(),
              'per_page': perPage.toString(),
            },
          ),
        )
        .then(
          (value) => [
            for (final r in value as List)
              mappers.showTimeResponseToShowTime(ShowTimeResponse.fromJson(r)),
          ],
        );
  }
}
