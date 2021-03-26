// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String? phoneNumber;
  @override
  final String fullName;
  @override
  final Gender gender;
  @override
  final String? avatar;
  @override
  final String? address;
  @override
  final DateTime? birthday;
  @override
  final Location? location;
  @override
  final bool isCompleted;
  @override
  final bool isActive;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._(
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
    BuiltValueNullFieldError.checkNotNull(uid, 'User', 'uid');
    BuiltValueNullFieldError.checkNotNull(email, 'User', 'email');
    BuiltValueNullFieldError.checkNotNull(fullName, 'User', 'fullName');
    BuiltValueNullFieldError.checkNotNull(gender, 'User', 'gender');
    BuiltValueNullFieldError.checkNotNull(isCompleted, 'User', 'isCompleted');
    BuiltValueNullFieldError.checkNotNull(isActive, 'User', 'isActive');
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
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
    return (newBuiltValueToStringHelper('User')
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

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

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

  Gender? _gender;
  Gender? get gender => _$this._gender;
  set gender(Gender? gender) => _$this._gender = gender;

  String? _avatar;
  String? get avatar => _$this._avatar;
  set avatar(String? avatar) => _$this._avatar = avatar;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  DateTime? _birthday;
  DateTime? get birthday => _$this._birthday;
  set birthday(DateTime? birthday) => _$this._birthday = birthday;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  bool? _isCompleted;
  bool? get isCompleted => _$this._isCompleted;
  set isCompleted(bool? isCompleted) => _$this._isCompleted = isCompleted;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UserBuilder();

  UserBuilder get _$this {
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
  void replace(User other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    _$User _$result;
    try {
      _$result = _$v ??
          new _$User._(
              uid: BuiltValueNullFieldError.checkNotNull(uid, 'User', 'uid'),
              email:
                  BuiltValueNullFieldError.checkNotNull(email, 'User', 'email'),
              phoneNumber: phoneNumber,
              fullName: BuiltValueNullFieldError.checkNotNull(
                  fullName, 'User', 'fullName'),
              gender: BuiltValueNullFieldError.checkNotNull(
                  gender, 'User', 'gender'),
              avatar: avatar,
              address: address,
              birthday: birthday,
              location: _location?.build(),
              isCompleted: BuiltValueNullFieldError.checkNotNull(
                  isCompleted, 'User', 'isCompleted'),
              isActive: BuiltValueNullFieldError.checkNotNull(
                  isActive, 'User', 'isActive'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
