import 'package:meta/meta.dart';

abstract class NotificationRepository {
  Stream<dynamic> getNotification({@required int page, @required int perPage});
}
