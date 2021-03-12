// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_local.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LocationLocal> _$locationLocalSerializer =
    new _$LocationLocalSerializer();
Serializer<UserLocal> _$userLocalSerializer = new _$UserLocalSerializer();

class _$LocationLocalSerializer implements StructuredSerializer<LocationLocal> {
  @override
  final Iterable<Type> types = const [LocationLocal, _$LocationLocal];
  @override
  final String wireName = 'LocationLocal';

  @override
  Iterable<Object?> serialize(Serializers serializers, LocationLocal object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'latitude',
      serializers.serialize(object.latitude,
          specifiedType: const FullType(double)),
      'longitude',
      serializers.serialize(object.longitude,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  LocationLocal deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LocationLocalBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'latitude':
          result.latitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'longitude':
          result.longitude = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$UserLocalSerializer implements StructuredSerializer<UserLocal> {
  @override
  final Iterable<Type> types = const [UserLocal, _$UserLocal];
  @override
  final String wireName = 'UserLocal';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserLocal object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'uid',
      serializers.serialize(object.uid, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'full_name',
      serializers.serialize(object.fullName,
          specifiedType: const FullType(String)),
      'gender',
      serializers.serialize(object.gender,
          specifiedType: const FullType(String)),
      'is_completed',
      serializers.serialize(object.isCompleted,
          specifiedType: const FullType(bool)),
      'is_active',
      serializers.serialize(object.isActive,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.phoneNumber;
    if (value != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.avatar;
    if (value != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.address;
    if (value != null) {
      result
        ..add('address')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.birthday;
    if (value != null) {
      result
        ..add('birthday')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.location;
    if (value != null) {
      result
        ..add('location')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(LocationLocal)));
    }
    return result;
  }

  @override
  UserLocal deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserLocalBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'uid':
          result.uid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone_number':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'full_name':
          result.fullName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gender':
          result.gender = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'address':
          result.address = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'birthday':
          result.birthday = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'location':
          result.location.replace(serializers.deserialize(value,
              specifiedType: const FullType(LocationLocal))! as LocationLocal);
          break;
        case 'is_completed':
          result.isCompleted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'is_active':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$LocationLocal extends LocationLocal {
  @override
  final double latitude;
  @override
  final double longitude;

  factory _$LocationLocal([void Function(LocationLocalBuilder)? updates]) =>
      (new LocationLocalBuilder()..update(updates)).build();

  _$LocationLocal._({required this.latitude, required this.longitude})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        latitude, 'LocationLocal', 'latitude');
    BuiltValueNullFieldError.checkNotNull(
        longitude, 'LocationLocal', 'longitude');
  }

  @override
  LocationLocal rebuild(void Function(LocationLocalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationLocalBuilder toBuilder() => new LocationLocalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationLocal &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, latitude.hashCode), longitude.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LocationLocal')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class LocationLocalBuilder
    implements Builder<LocationLocal, LocationLocalBuilder> {
  _$LocationLocal? _$v;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  LocationLocalBuilder();

  LocationLocalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationLocal other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LocationLocal;
  }

  @override
  void update(void Function(LocationLocalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LocationLocal build() {
    final _$result = _$v ??
        new _$LocationLocal._(
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, 'LocationLocal', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, 'LocationLocal', 'longitude'));
    replace(_$result);
    return _$result;
  }
}

class _$UserLocal extends UserLocal {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String? phoneNumber;
  @override
  final String fullName;
  @override
  final String gender;
  @override
  final String? avatar;
  @override
  final String? address;
  @override
  final DateTime? birthday;
  @override
  final LocationLocal? location;
  @override
  final bool isCompleted;
  @override
  final bool isActive;

  factory _$UserLocal([void Function(UserLocalBuilder)? updates]) =>
      (new UserLocalBuilder()..update(updates)).build();

  _$UserLocal._(
      {required this.uid,
      required this.email,
      this.phoneNumber,
      required this.fullName,
      required this.gender,
      this.avatar,
      this.address,
      this.birthday,
      this.location,
      required this.isCompleted,
      required this.isActive})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(uid, 'UserLocal', 'uid');
    BuiltValueNullFieldError.checkNotNull(email, 'UserLocal', 'email');
    BuiltValueNullFieldError.checkNotNull(fullName, 'UserLocal', 'fullName');
    BuiltValueNullFieldError.checkNotNull(gender, 'UserLocal', 'gender');
    BuiltValueNullFieldError.checkNotNull(
        isCompleted, 'UserLocal', 'isCompleted');
    BuiltValueNullFieldError.checkNotNull(isActive, 'UserLocal', 'isActive');
  }

  @override
  UserLocal rebuild(void Function(UserLocalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserLocalBuilder toBuilder() => new UserLocalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserLocal &&
        uid == other.uid &&
        email == other.email &&
        phoneNumber == other.phoneNumber &&
        fullName == other.fullName &&
        gender == other.gender &&
        avatar == other.avatar &&
        address == other.address &&
        birthday == other.birthday &&
        location == other.location &&
        isCompleted == other.isCompleted &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, uid.hashCode),
                                            email.hashCode),
                                        phoneNumber.hashCode),
                                    fullName.hashCode),
                                gender.hashCode),
                            avatar.hashCode),
                        address.hashCode),
                    birthday.hashCode),
                location.hashCode),
            isCompleted.hashCode),
        isActive.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserLocal')
          ..add('uid', uid)
          ..add('email', email)
          ..add('phoneNumber', phoneNumber)
          ..add('fullName', fullName)
          ..add('gender', gender)
          ..add('avatar', avatar)
          ..add('address', address)
          ..add('birthday', birthday)
          ..add('location', location)
          ..add('isCompleted', isCompleted)
          ..add('isActive', isActive))
        .toString();
  }
}

class UserLocalBuilder implements Builder<UserLocal, UserLocalBuilder> {
  _$UserLocal? _$v;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _gender;
  String? get gender => _$this._gender;
  set gender(String? gender) => _$this._gender = gender;

  String? _avatar;
  String? get avatar => _$this._avatar;
  set avatar(String? avatar) => _$this._avatar = avatar;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  DateTime? _birthday;
  DateTime? get birthday => _$this._birthday;
  set birthday(DateTime? birthday) => _$this._birthday = birthday;

  LocationLocalBuilder? _location;
  LocationLocalBuilder get location =>
      _$this._location ??= new LocationLocalBuilder();
  set location(LocationLocalBuilder? location) => _$this._location = location;

  bool? _isCompleted;
  bool? get isCompleted => _$this._isCompleted;
  set isCompleted(bool? isCompleted) => _$this._isCompleted = isCompleted;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UserLocalBuilder();

  UserLocalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uid = $v.uid;
      _email = $v.email;
      _phoneNumber = $v.phoneNumber;
      _fullName = $v.fullName;
      _gender = $v.gender;
      _avatar = $v.avatar;
      _address = $v.address;
      _birthday = $v.birthday;
      _location = $v.location?.toBuilder();
      _isCompleted = $v.isCompleted;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserLocal other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserLocal;
  }

  @override
  void update(void Function(UserLocalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserLocal build() {
    _$UserLocal _$result;
    try {
      _$result = _$v ??
          new _$UserLocal._(
              uid: BuiltValueNullFieldError.checkNotNull(
                  uid, 'UserLocal', 'uid'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'UserLocal', 'email'),
              phoneNumber: phoneNumber,
              fullName: BuiltValueNullFieldError.checkNotNull(
                  fullName, 'UserLocal', 'fullName'),
              gender: BuiltValueNullFieldError.checkNotNull(
                  gender, 'UserLocal', 'gender'),
              avatar: avatar,
              address: address,
              birthday: birthday,
              location: _location?.build(),
              isCompleted: BuiltValueNullFieldError.checkNotNull(
                  isCompleted, 'UserLocal', 'isCompleted'),
              isActive: BuiltValueNullFieldError.checkNotNull(
                  isActive, 'UserLocal', 'isActive'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UserLocal', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
