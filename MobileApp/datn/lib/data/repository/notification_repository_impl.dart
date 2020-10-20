import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/notification_repository.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/notification_response.dart';
import '../serializers.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final AuthClient _authClient;

  NotificationRepositoryImpl(this._authClient);

  @override
  Stream getNotification({int page, int perPage}) {
    final toResult = (dynamic json) {
      return serializers.deserialize(
        json,
        specifiedType: builtListNotificationResponse,
      ) as BuiltList<NotificationResponse>;
    };

    return Rx.fromCallable(
      () => _authClient
          .getBody(
            buildUrl(
              '/notifications',
              {
                'page': page.toString(),
                'per_page': perPage.toString(),
              },
            ),
          )
          .then(toResult),
    );
  }
}
