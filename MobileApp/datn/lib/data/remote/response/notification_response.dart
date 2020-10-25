import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'reservation_response.dart';

part 'notification_response.g.dart';

abstract class NotificationResponse
    implements Built<NotificationResponse, NotificationResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get title;

  String get body;

  String get to_user;

  NotificationResponse_ReservationResponse get reservation;

  DateTime get createdAt;

  DateTime get updatedAt;

  NotificationResponse._();

  factory NotificationResponse(
          [void Function(NotificationResponseBuilder) updates]) =
      _$NotificationResponse;

  static Serializer<NotificationResponse> get serializer =>
      _$notificationResponseSerializer;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<NotificationResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class NotificationResponse_ReservationResponse
    implements
        Built<NotificationResponse_ReservationResponse,
            NotificationResponse_ReservationResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get email;

  @nullable
  bool get is_active;

  int get original_price;

  String get phone_number;

  BuiltList<ProductIdAndQuantity> get products;

  int get total_price;

  ShowTimeFullResponse get show_time;

  String get user;

  String get payment_intent_id;

  DateTime get createdAt;

  DateTime get updatedAt;

  NotificationResponse_ReservationResponse._();

  factory NotificationResponse_ReservationResponse(
      [void Function(NotificationResponse_ReservationResponseBuilder)
          updates]) = _$NotificationResponse_ReservationResponse;

  static Serializer<NotificationResponse_ReservationResponse> get serializer =>
      _$notificationResponseReservationResponseSerializer;

  factory NotificationResponse_ReservationResponse.fromJson(
          Map<String, dynamic> json) =>
      serializers.deserializeWith<NotificationResponse_ReservationResponse>(
          serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
