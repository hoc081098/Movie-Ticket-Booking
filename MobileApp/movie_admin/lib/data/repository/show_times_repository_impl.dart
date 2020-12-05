import '../../domain/model/show_time.dart';
import '../../domain/repository/show_times_repository.dart';
import '../mappers.dart' as mappers;
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/show_time_response.dart';

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
