import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../../utils/utils.dart';
import '../../serializers.dart';

part 'user_response.g.dart';

abstract class LocationResponse
    implements Built<LocationResponse, LocationResponseBuilder> {
  @BuiltValueField(wireName: 'coordinates')
  BuiltList<double>? get coordinates;

  double? get longitude => coordinates.isNullOrEmpty ? null : coordinates![0];

  double? get latitude => coordinates.isNullOrEmpty ? null : coordinates![1];

  LocationResponse._();

  factory LocationResponse([void Function(LocationResponseBuilder) updates]) =
      _$LocationResponse;

  static Serializer<LocationResponse> get serializer =>
      _$locationResponseSerializer;

  factory LocationResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<LocationResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}

abstract class UserResponse
    implements Built<UserResponse, UserResponseBuilder> {
  @BuiltValueField(wireName: 'uid')
  String get uid;

  @BuiltValueField(wireName: 'email')
  String get email;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: 'full_name')
  String get fullName;

  @BuiltValueField(wireName: 'gender')
  String get gender;

  @BuiltValueField(wireName: 'avatar')
  String? get avatar;

  @BuiltValueField(wireName: 'address')
  String? get address;

  @BuiltValueField(wireName: 'birthday')
  DateTime? get birthday;

  @BuiltValueField(wireName: 'location')
  LocationResponse? get location;

  @BuiltValueField(wireName: 'is_completed')
  bool get isCompleted;

  @BuiltValueField(wireName: 'is_active')
  bool? get isActive;

  String get role;

  UserResponse._();

  factory UserResponse([void Function(UserResponseBuilder) updates]) =
      _$UserResponse;

  static Serializer<UserResponse> get serializer => _$userResponseSerializer;

  factory UserResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<UserResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
