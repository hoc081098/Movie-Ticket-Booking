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
  Iterable<Object?> serialize(Serializers serializers, TheatreResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'location',
      serializers.serialize(object.location,
          specifiedType: const FullType(LocationResponse)),
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
    Object? value;
    value = object.is_active;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.distance;
    if (value != null) {
      result
        ..add('distance')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.thumbnail;
    if (value != null) {
      result
        ..add('thumbnail')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.cover;
    if (value != null) {
      result
        ..add('cover')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  TheatreResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TheatreResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'location':
          result.location.replace(serializers.deserialize(value,
                  specifiedType: const FullType(LocationResponse))!
              as LocationResponse);
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'rooms':
          result.rooms.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
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
        case 'distance':
          result.distance = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'thumbnail':
          result.thumbnail = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'cover':
          result.cover = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
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
  final bool? is_active;
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
  final String? email;
  @override
  final String opening_hours;
  @override
  final String room_summary;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final double? distance;
  @override
  final String? thumbnail;
  @override
  final String? cover;

  factory _$TheatreResponse([void Function(TheatreResponseBuilder)? updates]) =>
      (new TheatreResponseBuilder()..update(updates)).build();

  _$TheatreResponse._(
      {required this.id,
      required this.location,
      this.is_active,
      required this.rooms,
      required this.name,
      required this.address,
      required this.phone_number,
      required this.description,
      this.email,
      required this.opening_hours,
      required this.room_summary,
      required this.createdAt,
      required this.updatedAt,
      this.distance,
      this.thumbnail,
      this.cover})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'TheatreResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        location, 'TheatreResponse', 'location');
    BuiltValueNullFieldError.checkNotNull(rooms, 'TheatreResponse', 'rooms');
    BuiltValueNullFieldError.checkNotNull(name, 'TheatreResponse', 'name');
    BuiltValueNullFieldError.checkNotNull(
        address, 'TheatreResponse', 'address');
    BuiltValueNullFieldError.checkNotNull(
        phone_number, 'TheatreResponse', 'phone_number');
    BuiltValueNullFieldError.checkNotNull(
        description, 'TheatreResponse', 'description');
    BuiltValueNullFieldError.checkNotNull(
        opening_hours, 'TheatreResponse', 'opening_hours');
    BuiltValueNullFieldError.checkNotNull(
        room_summary, 'TheatreResponse', 'room_summary');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'TheatreResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'TheatreResponse', 'updatedAt');
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
        updatedAt == other.updatedAt &&
        distance == other.distance &&
        thumbnail == other.thumbnail &&
        cover == other.cover;
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
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    0,
                                                                    id
                                                                        .hashCode),
                                                                location
                                                                    .hashCode),
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
                    updatedAt.hashCode),
                distance.hashCode),
            thumbnail.hashCode),
        cover.hashCode));
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
          ..add('updatedAt', updatedAt)
          ..add('distance', distance)
          ..add('thumbnail', thumbnail)
          ..add('cover', cover))
        .toString();
  }
}

class TheatreResponseBuilder
    implements Builder<TheatreResponse, TheatreResponseBuilder> {
  _$TheatreResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  LocationResponseBuilder? _location;
  LocationResponseBuilder get location =>
      _$this._location ??= new LocationResponseBuilder();
  set location(LocationResponseBuilder? location) =>
      _$this._location = location;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  ListBuilder<String>? _rooms;
  ListBuilder<String> get rooms => _$this._rooms ??= new ListBuilder<String>();
  set rooms(ListBuilder<String>? rooms) => _$this._rooms = rooms;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _phone_number;
  String? get phone_number => _$this._phone_number;
  set phone_number(String? phone_number) => _$this._phone_number = phone_number;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _opening_hours;
  String? get opening_hours => _$this._opening_hours;
  set opening_hours(String? opening_hours) =>
      _$this._opening_hours = opening_hours;

  String? _room_summary;
  String? get room_summary => _$this._room_summary;
  set room_summary(String? room_summary) => _$this._room_summary = room_summary;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  double? _distance;
  double? get distance => _$this._distance;
  set distance(double? distance) => _$this._distance = distance;

  String? _thumbnail;
  String? get thumbnail => _$this._thumbnail;
  set thumbnail(String? thumbnail) => _$this._thumbnail = thumbnail;

  String? _cover;
  String? get cover => _$this._cover;
  set cover(String? cover) => _$this._cover = cover;

  TheatreResponseBuilder();

  TheatreResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _location = $v.location.toBuilder();
      _is_active = $v.is_active;
      _rooms = $v.rooms.toBuilder();
      _name = $v.name;
      _address = $v.address;
      _phone_number = $v.phone_number;
      _description = $v.description;
      _email = $v.email;
      _opening_hours = $v.opening_hours;
      _room_summary = $v.room_summary;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _distance = $v.distance;
      _thumbnail = $v.thumbnail;
      _cover = $v.cover;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TheatreResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TheatreResponse;
  }

  @override
  void update(void Function(TheatreResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TheatreResponse build() {
    _$TheatreResponse _$result;
    try {
      _$result = _$v ??
          new _$TheatreResponse._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'TheatreResponse', 'id'),
              location: location.build(),
              is_active: is_active,
              rooms: rooms.build(),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'TheatreResponse', 'name'),
              address: BuiltValueNullFieldError.checkNotNull(
                  address, 'TheatreResponse', 'address'),
              phone_number: BuiltValueNullFieldError.checkNotNull(
                  phone_number, 'TheatreResponse', 'phone_number'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, 'TheatreResponse', 'description'),
              email: email,
              opening_hours: BuiltValueNullFieldError.checkNotNull(
                  opening_hours, 'TheatreResponse', 'opening_hours'),
              room_summary: BuiltValueNullFieldError.checkNotNull(
                  room_summary, 'TheatreResponse', 'room_summary'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'TheatreResponse', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'TheatreResponse', 'updatedAt'),
              distance: distance,
              thumbnail: thumbnail,
              cover: cover);
    } catch (_) {
      late String _$failedField;
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
