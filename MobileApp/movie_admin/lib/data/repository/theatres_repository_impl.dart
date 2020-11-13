import 'package:movie_admin/data/remote/response/theatre_response.dart';

import '../../domain/model/theatre.dart';
import '../../domain/repository/theatres_repository.dart';
import '../mappers.dart' as mappers;
import '../remote/auth_client.dart';
import '../remote/base_url.dart';

class TheatresRepositoryImpl implements TheatresRepository {
  final AuthClient _authClient;

  TheatresRepositoryImpl(this._authClient);

  @override
  Future<List<Theatre>> getTheatres() async {
    final json = await _authClient.getBody(buildUrl('/theatres/nearby'));
    return [
      for (final r in json)
        mappers.theatreResponseToTheatre(TheatreResponse.fromJson(r)),
    ];
  }
}
