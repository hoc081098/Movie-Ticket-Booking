import 'package:built_collection/built_collection.dart';
import '../model/notification.dart';

abstract class NotificationRepository {
  Stream<BuiltList<Notification>> getNotification({
    required int page,
    required int perPage,
  });

  Future<void> deleteNotificationById(String id);
}
