// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theatre_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TheatreResponse> _$theatreResponseSerializer =
    new _$TheatreResponseSerializer();

class _$TheatreResponseSerializer
    implements StructuredSerializer<TheatreResponse> {
  @override
  final Iterable<Type> types = const [TheatreResponse, _$TheatreResponse];
  @override
  final String wireName = 'TheatreResponse';

  @override
  Iterable<Object> serialize(Serializers serializers, TheatreResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'location',
      serializers.serialize(object.location,
          specifiedType: const FullType(LocationResponse)),
      'is_active',
      serializers.serialize(object.is_active,
          specifiedType: const FullType(bool)),
      'rooms',
      serializers.serialize(object.rooms,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'address',
      serializers.serialize(object.address,
          specifiedType: const FullType(String)),
      'phone_number',
      serializers.serialize(object.phone_number,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'opening_hours',
      serializers.serialize(object.opening_hours,
          specifiedType: const FullType(String)),
      'room_summary',
      serializers.serialize(object.room_summary,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
    ];
    if (object.email != null) {
      result
        ..add('email')
        ..add(serializers.serialize(object.email,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TheatreResponse deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TheatreResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'location':
          result.location.replace(serializers.deserialize(value,
                  specifiedType: const FullType(LocationResponse))
              as LocationResponse);
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'rooms':
          result.rooms.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'address':
          result.address = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'phone_number':
          result.phone_number = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'opening_hours':
          result.opening_hours = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'room_summary':
          result.room_summary = serializers.deserialize(value,
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

class _$TheatreResponse extends TheatreResponse {
  @override
  final String id;
  @override
  final LocationResponse location;
  @override
  final bool is_active;
  @override
  final BuiltList<String> rooms;
  @override
  final String name;
  @override
  final String address;
  @override
  final String phone_number;
  @override
  final String description;
  @override
  final String email;
  @override
  final String opening_hours;
  @override
  final String room_summary;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$TheatreResponse([void Function(TheatreResponseBuilder) updates]) =>
      (new TheatreResponseBuilder()..update(updates)).build();

  _$TheatreResponse._(
      {this.id,
      this.location,
      this.is_active,
      this.rooms,
      this.name,
      this.address,
      this.phone_number,
      this.description,
      this.email,
      this.opening_hours,
      this.room_summary,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'id');
    }
    if (location == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'location');
    }
    if (is_active == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'is_active');
    }
    if (rooms == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'rooms');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'name');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'address');
    }
    if (phone_number == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'phone_number');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'description');
    }
    if (opening_hours == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'opening_hours');
    }
    if (room_summary == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'room_summary');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('TheatreResponse', 'updatedAt');
    }
  }

  @override
  TheatreResponse rebuild(void Function(TheatreResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TheatreResponseBuilder toBuilder() =>
      new TheatreResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TheatreResponse &&
        id == other.id &&
        location == other.location &&
        is_active == other.is_active &&
        rooms == other.rooms &&
        name == other.name &&
        address == other.address &&
        phone_number == other.phone_number &&
        description == other.description &&
        email == other.email &&
        opening_hours == other.opening_hours &&
        room_summary == other.room_summary &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
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
                                            $jc(
                                                $jc($jc(0, id.hashCode),
                                                    location.hashCode),
                                                is_active.hashCode),
                                            rooms.hashCode),
                                        name.hashCode),
                                    address.hashCode),
                                phone_number.hashCode),
                            description.hashCode),
                        email.hashCode),
                    opening_hours.hashCode),
                room_summary.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TheatreResponse')
          ..add('id', id)
          ..add('location', location)
          ..add('is_active', is_active)
          ..add('rooms', rooms)
          ..add('name', name)
          ..add('address', address)
          ..add('phone_number', phone_number)
          ..add('description', description)
          ..add('email', email)
          ..add('opening_hours', opening_hours)
          ..add('room_summary', room_summary)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class TheatreResponseBuilder
    implements Builder<TheatreResponse, TheatreResponseBuilder> {
  _$TheatreResponse _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  LocationResponseBuilder _location;
  LocationResponseBuilder get location =>
      _$this._location ??= new LocationResponseBuilder();
  set location(LocationResponseBuilder location) => _$this._location = location;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  ListBuilder<String> _rooms;
  ListBuilder<String> get rooms => _$this._rooms ??= new ListBuilder<String>();
  set rooms(ListBuilder<String> rooms) => _$this._rooms = rooms;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _address;
  String get address => _$this._address;
  set address(String address) => _$this._address = address;

  String _phone_number;
  String get phone_number => _$this._phone_number;
  set phone_number(String phone_number) => _$this._phone_number = phone_number;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _opening_hours;
  String get opening_hours => _$this._opening_hours;
  set opening_hours(String opening_hours) =>
      _$this._opening_hours = opening_hours;

  String _room_summary;
  String get room_summary => _$this._room_summary;
  set room_summary(String room_summary) => _$this._room_summary = room_summary;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  TheatreResponseBuilder();

  TheatreResponseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _location = _$v.location?.toBuilder();
      _is_active = _$v.is_active;
      _rooms = _$v.rooms?.toBuilder();
      _name = _$v.name;
      _address = _$v.address;
      _phone_number = _$v.phone_number;
      _description = _$v.description;
      _email = _$v.email;
      _opening_hours = _$v.opening_hours;
      _room_summary = _$v.room_summary;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TheatreResponse other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TheatreResponse;
  }

  @override
  void update(void Function(TheatreResponseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TheatreResponse build() {
    _$TheatreResponse _$result;
    try {
      _$result = _$v ??
          new _$TheatreResponse._(
              id: id,
              location: location.build(),
              is_active: is_active,
              rooms: rooms.build(),
              name: name,
              address: address,
              phone_number: phone_number,
              description: description,
              email: email,
              opening_hours: opening_hours,
              room_summary: room_summary,
              createdAt: createdAt,
              updatedAt: updatedAt);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'location';
        location.build();

        _$failedField = 'rooms';
        rooms.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TheatreResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
