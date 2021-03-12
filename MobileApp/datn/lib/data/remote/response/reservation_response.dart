import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'movie_response.dart';
import 'theatre_response.dart';
import 'user_response.dart';

part 'reservation_response.g.dart';

abstract class ReservationResponse
    implements Built<ReservationResponse, ReservationResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  DateTime get createdAt;

  String get email;

  bool? get is_active;

  int get original_price;

  String get payment_intent_id;

  String get phone_number;

  BuiltList<ProductIdAndQuantity> get products;

  ShowTimeFullResponse get show_time;

  int get total_price;

  DateTime get updatedAt;

  UserResponse get user;

  ReservationResponse._();

  factory ReservationResponse(
          [void Function(ReservationResponseBuilder) updates]) =
      _$ReservationResponse;

  static Serializer<ReservationResponse> get serializer =>
      _$reservationResponseSerializer;

  factory ReservationResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<ReservationResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}

abstract class ProductIdAndQuantity
    implements Built<ProductIdAndQuantity, ProductIdAndQuantityBuilder> {
  String get id;

  int get quantity;

  ProductIdAndQuantity._();

  factory ProductIdAndQuantity(
          [void Function(ProductIdAndQuantityBuilder) updates]) =
      _$ProductIdAndQuantity;

  static Serializer<ProductIdAndQuantity> get serializer =>
      _$productIdAndQuantitySerializer;

  factory ProductIdAndQuantity.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<ProductIdAndQuantity>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}

abstract class ShowTimeFullResponse
    implements Built<ShowTimeFullResponse, ShowTimeFullResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  bool? get is_active;

  MovieResponse get movie;

  TheatreResponse get theatre;

  String get room;

  DateTime get end_time;

  DateTime get start_time;

  DateTime get createdAt;

  DateTime get updatedAt;

  ShowTimeFullResponse._();

  factory ShowTimeFullResponse(
          [void Function(ShowTimeFullResponseBuilder) updates]) =
      _$ShowTimeFullResponse;

  static Serializer<ShowTimeFullResponse> get serializer =>
      _$showTimeFullResponseSerializer;

  factory ShowTimeFullResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<ShowTimeFullResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
