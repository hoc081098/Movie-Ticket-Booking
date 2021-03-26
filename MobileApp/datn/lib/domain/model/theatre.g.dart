// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theatre.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Theatre extends Theatre {
  @override
  final String id;
  @override
  final Location location;
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
  final String thumbnail;
  @override
  final String cover;

  factory _$Theatre([void Function(TheatreBuilder)? updates]) =>
      (new TheatreBuilder()..update(updates)).build();

  _$Theatre._(
      {required this.id,
      required this.location,
      required this.is_active,
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
      required this.thumbnail,
      required this.cover})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Theatre', 'id');
    BuiltValueNullFieldError.checkNotNull(location, 'Theatre', 'location');
    BuiltValueNullFieldError.checkNotNull(is_active, 'Theatre', 'is_active');
    BuiltValueNullFieldError.checkNotNull(rooms, 'Theatre', 'rooms');
    BuiltValueNullFieldError.checkNotNull(name, 'Theatre', 'name');
    BuiltValueNullFieldError.checkNotNull(address, 'Theatre', 'address');
    BuiltValueNullFieldError.checkNotNull(
        phone_number, 'Theatre', 'phone_number');
    BuiltValueNullFieldError.checkNotNull(
        description, 'Theatre', 'description');
    BuiltValueNullFieldError.checkNotNull(
        opening_hours, 'Theatre', 'opening_hours');
    BuiltValueNullFieldError.checkNotNull(
        room_summary, 'Theatre', 'room_summary');
    BuiltValueNullFieldError.checkNotNull(createdAt, 'Theatre', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, 'Theatre', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(thumbnail, 'Theatre', 'thumbnail');
    BuiltValueNullFieldError.checkNotNull(cover, 'Theatre', 'cover');
  }

  @override
  Theatre rebuild(void Function(TheatreBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TheatreBuilder toBuilder() => new TheatreBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Theatre &&
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
    return (newBuiltValueToStringHelper('Theatre')
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

class TheatreBuilder implements Builder<Theatre, TheatreBuilder> {
  _$Theatre? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

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

  TheatreBuilder();

  TheatreBuilder get _$this {
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
  void replace(Theatre other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Theatre;
  }

  @override
  void update(void Function(TheatreBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Theatre build() {
    _$Theatre _$result;
    try {
      _$result = _$v ??
          new _$Theatre._(
              id: BuiltValueNullFieldError.checkNotNull(id, 'Theatre', 'id'),
              location: location.build(),
              is_active: BuiltValueNullFieldError.checkNotNull(
                  is_active, 'Theatre', 'is_active'),
              rooms: rooms.build(),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'Theatre', 'name'),
              address: BuiltValueNullFieldError.checkNotNull(
                  address, 'Theatre', 'address'),
              phone_number: BuiltValueNullFieldError.checkNotNull(
                  phone_number, 'Theatre', 'phone_number'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, 'Theatre', 'description'),
              email: email,
              opening_hours: BuiltValueNullFieldError.checkNotNull(
                  opening_hours, 'Theatre', 'opening_hours'),
              room_summary: BuiltValueNullFieldError.checkNotNull(
                  room_summary, 'Theatre', 'room_summary'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'Theatre', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'Theatre', 'updatedAt'),
              distance: distance,
              thumbnail: BuiltValueNullFieldError.checkNotNull(
                  thumbnail, 'Theatre', 'thumbnail'),
              cover:
                  BuiltValueNullFieldError.checkNotNull(cover, 'Theatre', 'cover'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();

        _$failedField = 'rooms';
        rooms.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Theatre', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
