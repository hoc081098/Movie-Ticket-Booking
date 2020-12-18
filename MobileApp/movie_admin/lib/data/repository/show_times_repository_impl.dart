import 'package:built_collection/built_collection.dart';
import 'package:built_collection/src/map.dart';
import 'package:tuple/tuple.dart';

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

  @override
  Future<void> addShowTime(
      {String movieId,
      String theatreId,
      DateTime startTime,
      List<Tuple2<String, int>> tickets}) async {
    final res = await _authClient.postBody(
      buildUrl('/admin-show-times'),
      body: {
        'movie': movieId,
        'theatre': theatreId,
        'start_time': startTime.toUtc().toIso8601String(),
        'tickets': [
          for (final t in tickets)
            {
              'seat': t.item1,
              'price': t.item2,
            },
        ],
      },
    );

    print(res);
  }

  @override
  Future<List<Tuple2<DateTime, DateTime>>> availablePeriods(
      String theatre_id, DateTime day) async {
    final res = await _authClient.getBody(
      buildUrl(
        '/admin-show-times/available-periods',
        {
          'theatre_id': theatre_id,
          'day': day.toUtc().toIso8601String(),
        },
      ),
    ) as List;

    return [
      for (final r in res)
        Tuple2(
          DateTime.parse(r['start'])
              .also((v) => print('$v ${v.isUtc}'))
              .toLocal(),
          DateTime.parse(r['end'])
              .also((v) => print('$v ${v.isUtc}'))
              .toLocal(),
        )
    ];
  }

  @override
  Future<BuiltMap<String, int>> report(String theatre_id, String MMyyyy) async {
    final map = await _authClient.getBody(
      buildUrl(
        '/admin-show-times/report',
        {
          'MMyyyy': MMyyyy,
          'theatre_id': theatre_id,
        },
      ),
    ) as Map<String, dynamic>;

    return BuiltMap<String, int>.from(map);
  }
}

extension _E<T> on T {
  T also(void Function(T) block) {
    block(this);
    return this;
  }
}
