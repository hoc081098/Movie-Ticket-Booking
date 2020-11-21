import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart' hide Notification;

import '../../domain/model/notification.dart';
import '../../domain/repository/notification_repository.dart';
import '../../utils/type_defs.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/notification_response.dart';
import '../serializers.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final AuthClient _authClient;
  final Function1<NotificationResponse, Notification>
      _notificationResponseToNotification;

  NotificationRepositoryImpl(
    this._authClient,
    this._notificationResponseToNotification,
  );

  @override
  Stream<BuiltList<Notification>> getNotification({int page, int perPage}) {
    final toResult = (dynamic json) {
      final responses = serializers.deserialize(
        json,
        specifiedType: builtListNotificationResponse,
      ) as BuiltList<NotificationResponse>;
      return [
        for (final r in responses) _notificationResponseToNotification(r),
      ].build();
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

  @override
  Future<void> deleteNotificationById(String id) =>
      _authClient.deleteBody(buildUrl('/notifications/$id'));
}
