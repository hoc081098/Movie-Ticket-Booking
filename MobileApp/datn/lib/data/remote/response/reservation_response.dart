import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'reservation_response.g.dart';

abstract class ReservationResponse
    implements Built<ReservationResponse, ReservationResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  DateTime get createdAt;

  String get email;

  @nullable
  bool get is_active;

  int get original_price;

  String get payment_intent_id;

  String get phone_number;

  BuiltList<ProductAndCountResponse> get products;

  String get show_time;

  int get total_price;

  DateTime get updatedAt;

  String get user;

  ReservationResponse._();

  factory ReservationResponse(
          [void Function(ReservationResponseBuilder) updates]) =
      _$ReservationResponse;

  static Serializer<ReservationResponse> get serializer =>
      _$reservationResponseSerializer;

  factory ReservationResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<ReservationResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class ProductAndCountResponse
    implements Built<ProductAndCountResponse, ProductAndCountResponseBuilder> {
  String get id;

  int get quantity;

  ProductAndCountResponse._();

  factory ProductAndCountResponse(
          [void Function(ProductAndCountResponseBuilder) updates]) =
      _$ProductAndCountResponse;

  static Serializer<ProductAndCountResponse> get serializer =>
      _$productAndCountResponseSerializer;

  factory ProductAndCountResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<ProductAndCountResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
