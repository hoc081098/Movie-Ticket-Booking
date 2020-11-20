import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'product_response.dart';
import 'promotion_response.dart';
import 'reservation_response.dart';
import 'ticket_response.dart';

part 'full_reservation_response.g.dart';

abstract class FullReservationResponse
    implements Built<FullReservationResponse, FullReservationResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  DateTime get createdAt;

  String get email;

  @nullable
  bool get is_active;

  int get original_price;

  String get payment_intent_id;

  String get phone_number;

  BuiltList<ProductAndQuantityResponse> get products;

  ShowTimeFullResponse get show_time;

  int get total_price;

  DateTime get updatedAt;

  String get user;

  BuiltList<TicketResponse> get tickets;

  @nullable
  PromotionResponse get promotion_id;

  FullReservationResponse._();

  factory FullReservationResponse(
          [void Function(FullReservationResponseBuilder) updates]) =
      _$FullReservationResponse;

  static Serializer<FullReservationResponse> get serializer =>
      _$fullReservationResponseSerializer;

  factory FullReservationResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<FullReservationResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class ProductAndQuantityResponse
    implements
        Built<ProductAndQuantityResponse, ProductAndQuantityResponseBuilder> {
  @BuiltValueField(wireName: 'product_id')
  ProductResponse get product;

  int get quantity;

  ProductAndQuantityResponse._();

  factory ProductAndQuantityResponse(
          [void Function(ProductAndQuantityResponseBuilder) updates]) =
      _$ProductAndQuantityResponse;

  static Serializer<ProductAndQuantityResponse> get serializer =>
      _$productAndQuantityResponseSerializer;

  factory ProductAndQuantityResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<ProductAndQuantityResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
