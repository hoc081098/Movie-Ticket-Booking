// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LocationResponse> _$locationResponseSerializer =
    new _$LocationResponseSerializer();
Serializer<UserResponse> _$userResponseSerializer =
    new _$UserResponseSerializer();

class _$LocationResponseSerializer
    implements StructuredSerializer<LocationResponse> {
  @override
  final Iterable<Type> types = const [LocationResponse, _$LocationResponse];
  @override
  final String wireName = 'LocationResponse';

  @override
  Iterable<Object> serialize(Serializers serializers, LocationResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.coordinates != null) {
      result
        ..add('coordinates')
        ..add(serializers.serialize(object.coordinates,
            specifiedType:
                const FullType(BuiltList, const [const FullType(double)])));
    }
    return result;
  }

  @override
  LocationResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LocationResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'coordinates':
          result.coordinates.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(double)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$UserResponseSerializer implements StructuredSerializer<UserResponse> {
  @override
  final Iterable<Type> types = const [UserResponse, _$UserResponse];
  @override
  final String wireName = 'UserResponse';

  @override
  Iterable<Object> serialize(Serializers serializers, UserResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
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
      'role',
      serializers.serialize(object.role, specifiedType: const FullType(String)),
    ];
    if (object.phoneNumber != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(object.phoneNumber,
            specifiedType: const FullType(String)));
    }
    if (object.avatar != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(object.avatar,
            specifiedType: const FullType(String)));
    }
    if (object.address != null) {
      result
        ..add('address')
        ..add(serializers.serialize(object.address,
            specifiedType: const FullType(String)));
    }
    if (object.birthday != null) {
      result
        ..add('birthday')
        ..add(serializers.serialize(object.birthday,
            specifiedType: const FullType(DateTime)));
    }
    if (object.location != null) {
      result
        ..add('location')
        ..add(serializers.serialize(object.location,
            specifiedType: const FullType(LocationResponse)));
    }
    if (object.isActive != null) {
      result
        ..add('is_active')
        ..add(serializers.serialize(object.isActive,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  UserResponse deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
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
                  specifiedType: const FullType(LocationResponse))
              as LocationResponse);
          break;
        case 'is_completed':
          result.isCompleted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'is_active':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'role':
          result.role = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$LocationResponse extends LocationResponse {
  @override
  final BuiltList<double> coordinates;

  factory _$LocationResponse(
          [void Function(LocationResponseBuilder) updates]) =>
      (new LocationResponseBuilder()..update(updates)).build();

  _$LocationResponse._({this.coordinates}) : super._();

  @override
  LocationResponse rebuild(void Function(LocationResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationResponseBuilder toBuilder() =>
      new LocationResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LocationResponse && coordinates == other.coordinates;
  }

  @override
  int get hashCode {
    return $jf($jc(0, coordinates.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LocationResponse')
          ..add('coordinates', coordinates))
        .toString();
  }
}

class LocationResponseBuilder
    implements Builder<LocationResponse, LocationResponseBuilder> {
  _$LocationResponse _$v;

  ListBuilder<double> _coordinates;
  ListBuilder<double> get coordinates =>
      _$this._coordinates ??= new ListBuilder<double>();
  set coordinates(ListBuilder<double> coordinates) =>
      _$this._coordinates = coordinates;

  LocationResponseBuilder();

  LocationResponseBuilder get _$this {
    if (_$v != null) {
      _coordinates = _$v.coordinates?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LocationResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LocationResponse;
  }

  @override
  void update(void Function(LocationResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LocationResponse build() {
    _$LocationResponse _$result;
    try {
      _$result =
          _$v ?? new _$LocationResponse._(coordinates: _coordinates?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'coordinates';
        _coordinates?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'LocationResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$UserResponse extends UserResponse {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final String fullName;
  @override
  final String gender;
  @override
  final String avatar;
  @override
  final String address;
  @override
  final DateTime birthday;
  @override
  final LocationResponse location;
  @override
  final bool isCompleted;
  @override
  final bool isActive;
  @override
  final String role;

  factory _$UserResponse([void Function(UserResponseBuilder) updates]) =>
      (new UserResponseBuilder()..update(updates)).build();

  _$UserResponse._(
      {this.uid,
      this.email,
      this.phoneNumber,
      this.fullName,
      this.gender,
      this.avatar,
      this.address,
      this.birthday,
      this.location,
      this.isCompleted,
      this.isActive,
      this.role})
      : super._() {
    if (uid == null) {
      throw new BuiltValueNullFieldError('UserResponse', 'uid');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('UserResponse', 'email');
    }
    if (fullName == null) {
      throw new BuiltValueNullFieldError('UserResponse', 'fullName');
    }
    if (gender == null) {
      throw new BuiltValueNullFieldError('UserResponse', 'gender');
    }
    if (isCompleted == null) {
      throw new BuiltValueNullFieldError('UserResponse', 'isCompleted');
    }
    if (role == null) {
      throw new BuiltValueNullFieldError('UserResponse', 'role');
    }
  }

  @override
  UserResponse rebuild(void Function(UserResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserResponseBuilder toBuilder() => new UserResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserResponse &&
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
        isActive == other.isActive &&
        role == other.role;
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
            isActive.hashCode),
        role.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserResponse')
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
          ..add('isActive', isActive)
          ..add('role', role))
        .toString();
  }
}

class UserResponseBuilder
    implements Builder<UserResponse, UserResponseBuilder> {
  _$UserResponse _$v;

  String _uid;
  String get uid => _$this._uid;
  set uid(String uid) => _$this._uid = uid;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _phoneNumber;
  String get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String phoneNumber) => _$this._phoneNumber = phoneNumber;

  String _fullName;
  String get fullName => _$this._fullName;
  set fullName(String fullName) => _$this._fullName = fullName;

  String _gender;
  String get gender => _$this._gender;
  set gender(String gender) => _$this._gender = gender;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  DateTime _birthday;
  DateTime get birthday => _$this._birthday;
  set birthday(DateTime birthday) => _$this._birthday = birthday;

  LocationResponseBuilder _location;
  LocationResponseBuilder get location =>
      _$this._location ??= new LocationResponseBuilder();
  set location(LocationResponseBuilder location) => _$this._location = location;

  bool _isCompleted;
  bool get isCompleted => _$this._isCompleted;
  set isCompleted(bool isCompleted) => _$this._isCompleted = isCompleted;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  String _role;
  String get role => _$this._role;
  set role(String role) => _$this._role = role;

  UserResponseBuilder();

  UserResponseBuilder get _$this {
    if (_$v != null) {
      _uid = _$v.uid;
      _email = _$v.email;
      _phoneNumber = _$v.phoneNumber;
      _fullName = _$v.fullName;
      _gender = _$v.gender;
      _avatar = _$v.avatar;
      _address = _$v.address;
      _birthday = _$v.birthday;
      _location = _$v.location?.toBuilder();
      _isCompleted = _$v.isCompleted;
      _isActive = _$v.isActive;
      _role = _$v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserResponse;
  }

  @override
  void update(void Function(UserResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserResponse build() {
    _$UserResponse _$result;
    try {
      _$result = _$v ??
          new _$UserResponse._(
              uid: uid,
              email: email,
              phoneNumber: phoneNumber,
              fullName: fullName,
              gender: gender,
              avatar: avatar,
              address: address,
              birthday: birthday,
              location: _location?.build(),
              isCompleted: isCompleted,
              isActive: isActive,
              role: role);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UserResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
