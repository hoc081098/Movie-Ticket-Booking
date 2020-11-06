import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'user_response.dart';

part 'theatre_response.g.dart';

abstract class TheatreResponse
    implements Built<TheatreResponse, TheatreResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  LocationResponse get location;

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

  TheatreResponse._();

  factory TheatreResponse([void Function(TheatreResponseBuilder) updates]) =
      _$TheatreResponse;

  static Serializer<TheatreResponse> get serializer =>
      _$theatreResponseSerializer;

  factory TheatreResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<TheatreResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
