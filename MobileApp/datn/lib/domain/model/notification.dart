import 'package:built_value/built_value.dart';
import 'reservation.dart';

part 'notification.g.dart';

abstract class Notification
    implements Built<Notification, NotificationBuilder> {
  String get id;

  String get title;

  String get body;

  String get to_user;

  Reservation get reservation;

  DateTime get createdAt;

  DateTime get updatedAt;

  Notification._();

  factory Notification([void Function(NotificationBuilder) updates]) =
      _$Notification;
}
