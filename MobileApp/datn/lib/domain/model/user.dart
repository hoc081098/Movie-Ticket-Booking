import 'package:built_value/built_value.dart';

import 'location.dart';

part 'user.g.dart';

enum Gender { MALE, FEMALE }

abstract class User implements Built<User, UserBuilder> {
  String get uid;

  String get email;

  @nullable
  String get phoneNumber;

  String get fullName;

  Gender get gender;

  @nullable
  String get avatar;

  @nullable
  String get address;

  @nullable
  DateTime get birthday;

  @nullable
  Location get location;

  bool get isCompleted;

  bool get isActive;

  User._();

  factory User([void Function(UserBuilder) updates]) = _$User;
}
