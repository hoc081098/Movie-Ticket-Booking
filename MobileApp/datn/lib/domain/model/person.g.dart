// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Person extends Person {
  @override
  final bool is_active;
  @override
  final String id;
  @override
  final String avatar;
  @override
  final String full_name;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$Person([void Function(PersonBuilder) updates]) =>
      (new PersonBuilder()..update(updates)).build();

  _$Person._(
      {this.is_active,
      this.id,
      this.avatar,
      this.full_name,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (is_active == null) {
      throw new BuiltValueNullFieldError('Person', 'is_active');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Person', 'id');
    }
    if (full_name == null) {
      throw new BuiltValueNullFieldError('Person', 'full_name');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Person', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Person', 'updatedAt');
    }
  }

  @override
  Person rebuild(void Function(PersonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PersonBuilder toBuilder() => new PersonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Person &&
        is_active == other.is_active &&
        id == other.id &&
        avatar == other.avatar &&
        full_name == other.full_name &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, is_active.hashCode), id.hashCode),
                    avatar.hashCode),
                full_name.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Person')
          ..add('is_active', is_active)
          ..add('id', id)
          ..add('avatar', avatar)
          ..add('full_name', full_name)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PersonBuilder implements Builder<Person, PersonBuilder> {
  _$Person _$v;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  String _full_name;
  String get full_name => _$this._full_name;
  set full_name(String full_name) => _$this._full_name = full_name;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  PersonBuilder();

  PersonBuilder get _$this {
    if (_$v != null) {
      _is_active = _$v.is_active;
      _id = _$v.id;
      _avatar = _$v.avatar;
      _full_name = _$v.full_name;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Person other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Person;
  }

  @override
  void update(void Function(PersonBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Person build() {
    final _$result = _$v ??
        new _$Person._(
            is_active: is_active,
            id: id,
            avatar: avatar,
            full_name: full_name,
            createdAt: createdAt,
            updatedAt: updatedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
