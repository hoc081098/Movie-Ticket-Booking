import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/location.dart';
import '../../domain/model/theatre.dart';
import '../../domain/repository/theatre_repository.dart';
import '../../utils/utils.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/theatre_response.dart';
import '../serializers.dart';

class TheatreRepositoryImpl implements TheatreRepository {
  final AuthHttpClient _authClient;
  final Function1<TheatreResponse, Theatre> _theatreResponseToTheatre;

  TheatreRepositoryImpl(this._authClient, this._theatreResponseToTheatre);

  @override
  Stream<BuiltList<Theatre>> getNearbyTheatres(Location? location) {
    final toDomain = (dynamic json) {
      final response = serializers.deserialize(
        json,
        specifiedType: builtListTheatreResponse,
      ) as BuiltList<TheatreResponse>;

      return [for (final r in response) _theatreResponseToTheatre(r)].build();
    };

    return Rx.fromCallable(() => _authClient
        .getJson(
          buildUrl(
            '/theatres/nearby',
            location != null
                ? {
                    'lat': location.latitude.toString(),
                    'lng': location.longitude.toString(),
                  }
                : null,
          ),
        )
        .then(toDomain));
  }
}
