import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'product_response.dart';
import 'promotion_response.dart';
import 'ticket_response.dart';
import 'user_response.dart';

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

  UserResponse get user;

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

abstract class ShowTimeFullResponse
    implements Built<ShowTimeFullResponse, ShowTimeFullResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  @nullable
  bool get is_active;

  Res_MovieResponse get movie;

  Res_TheatreResponse get theatre;

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

  factory ShowTimeFullResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<ShowTimeFullResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class Res_MovieResponse
    implements Built<Res_MovieResponse, Res_MovieResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  @nullable
  bool get is_active;

  BuiltList<String> get actors;

  BuiltList<String> get directors;

  String get title;

  @nullable
  String get trailer_video_url;

  @nullable
  String get poster_url;

  @nullable
  String get overview;

  DateTime get released_date;

  int get duration;

  String get original_language;

  DateTime get createdAt;

  DateTime get updatedAt;

  String get age_type;

  double get rate_star;

  int get total_favorite;

  int get total_rate;

  Res_MovieResponse._();

  factory Res_MovieResponse([void Function(Res_MovieResponseBuilder) updates]) =
      _$Res_MovieResponse;

  static Serializer<Res_MovieResponse> get serializer =>
      _$resMovieResponseSerializer;

  factory Res_MovieResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<Res_MovieResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class Res_TheatreResponse
    implements Built<Res_TheatreResponse, Res_TheatreResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  Res_LocationResponse get location;

  @nullable
  bool get is_active;

  BuiltList<String> get rooms;

  String get name;

  String get address;

  String get phone_number;

  String get description;

  @nullable
  String get email;

  String get opening_hours;

  String get room_summary;

  DateTime get createdAt;

  DateTime get updatedAt;

  @nullable
  double get distance;

  @nullable
  String get thumbnail;

  @nullable
  String get cover;

  Res_TheatreResponse._();

  factory Res_TheatreResponse(
          [void Function(Res_TheatreResponseBuilder) updates]) =
      _$Res_TheatreResponse;

  static Serializer<Res_TheatreResponse> get serializer =>
      _$resTheatreResponseSerializer;

  factory Res_TheatreResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<Res_TheatreResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class Res_LocationResponse
    implements Built<Res_LocationResponse, Res_LocationResponseBuilder> {
  @nullable
  @BuiltValueField(wireName: 'coordinates')
  BuiltList<double> get coordinates;

  double get longitude => coordinates.isNullOrEmpty ? null : coordinates[0];

  double get latitude => coordinates.isNullOrEmpty ? null : coordinates[1];

  Res_LocationResponse._();

  factory Res_LocationResponse(
          [void Function(Res_LocationResponseBuilder) updates]) =
      _$Res_LocationResponse;

  static Serializer<Res_LocationResponse> get serializer =>
      _$resLocationResponseSerializer;

  factory Res_LocationResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<Res_LocationResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

extension IsNullOrEmptyIterableExtension<T> on Iterable<T> {
  bool get isNullOrEmpty => this == null || isEmpty;
}

class UserResponseSerializer implements PrimitiveSerializer<UserResponse> {
  @override
  UserResponse deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final list = serialized as List<dynamic>;
    final map = <String, dynamic>{};
    for (var i = 0; i + 1 < list.length; i += 2) {
      map[list[i] as String] = list[i + 1];
    }
    return UserResponse.fromJson(map);
  }

  @override
  Object serialize(Serializers serializers, UserResponse object,
          {FullType specifiedType = FullType.unspecified}) =>
      throw UnimplementedError('UserResponseSerializer.serialize');

  @override
  Iterable<Type> get types => const <Type>[UserResponse].build();

  @override
  String get wireName => 'UserResponse';
}
