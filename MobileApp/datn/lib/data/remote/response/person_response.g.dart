// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PersonResponse> _$personResponseSerializer =
    new _$PersonResponseSerializer();

class _$PersonResponseSerializer
    implements StructuredSerializer<PersonResponse> {
  @override
  final Iterable<Type> types = const [PersonResponse, _$PersonResponse];
  @override
  final String wireName = 'PersonResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, PersonResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'full_name',
      serializers.serialize(object.full_name,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
    ];
    Object? value;
    value = object.is_active;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.avatar;
    if (value != null) {
      result
        ..add('avatar')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  PersonResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PersonResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'avatar':
          result.avatar = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'full_name':
          result.full_name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$PersonResponse extends PersonResponse {
  @override
  final bool? is_active;
  @override
  final String id;
  @override
  final String? avatar;
  @override
  final String full_name;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$PersonResponse([void Function(PersonResponseBuilder)? updates]) =>
      (new PersonResponseBuilder()..update(updates)).build();

  _$PersonResponse._(
      {this.is_active,
      required this.id,
      this.avatar,
      required this.full_name,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'PersonResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        full_name, 'PersonResponse', 'full_name');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'PersonResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'PersonResponse', 'updatedAt');
  }

  @override
  PersonResponse rebuild(void Function(PersonResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PersonResponseBuilder toBuilder() =>
      new PersonResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PersonResponse &&
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
    return (newBuiltValueToStringHelper('PersonResponse')
          ..add('is_active', is_active)
          ..add('id', id)
          ..add('avatar', avatar)
          ..add('full_name', full_name)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class PersonResponseBuilder
    implements Builder<PersonResponse, PersonResponseBuilder> {
  _$PersonResponse? _$v;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _avatar;
  String? get avatar => _$this._avatar;
  set avatar(String? avatar) => _$this._avatar = avatar;

  String? _full_name;
  String? get full_name => _$this._full_name;
  set full_name(String? full_name) => _$this._full_name = full_name;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  PersonResponseBuilder();

  PersonResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _is_active = $v.is_active;
      _id = $v.id;
      _avatar = $v.avatar;
      _full_name = $v.full_name;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PersonResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PersonResponse;
  }

  @override
  void update(void Function(PersonResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PersonResponse build() {
    final _$result = _$v ??
        new _$PersonResponse._(
            is_active: is_active,
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'PersonResponse', 'id'),
            avatar: avatar,
            full_name: BuiltValueNullFieldError.checkNotNull(
                full_name, 'PersonResponse', 'full_name'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, 'PersonResponse', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, 'PersonResponse', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
