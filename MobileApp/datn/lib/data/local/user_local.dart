import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'user_local.g.dart';

abstract class LocationLocal
    implements Built<LocationLocal, LocationLocalBuilder> {
  double get latitude;

  double get longitude;

  LocationLocal._();

  factory LocationLocal([void Function(LocationLocalBuilder) updates]) =
      _$LocationLocal;

  static Serializer<LocationLocal> get serializer => _$locationLocalSerializer;

  factory LocationLocal.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<LocationLocal>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}

abstract class UserLocal implements Built<UserLocal, UserLocalBuilder> {
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
  LocationLocal? get location;

  @BuiltValueField(wireName: 'is_completed')
  bool get isCompleted;

  @BuiltValueField(wireName: 'is_active')
  bool get isActive;

  UserLocal._();

  factory UserLocal([void Function(UserLocalBuilder) updates]) = _$UserLocal;

  static Serializer<UserLocal> get serializer => _$userLocalSerializer;

  factory UserLocal.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<UserLocal>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
