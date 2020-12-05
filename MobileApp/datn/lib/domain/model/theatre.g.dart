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
  final String email;
  @override
  final String opening_hours;
  @override
  final String room_summary;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final double distance;
  @override
  final String thumbnail;
  @override
  final String cover;

  factory _$Theatre([void Function(TheatreBuilder) updates]) =>
      (new TheatreBuilder()..update(updates)).build();

  _$Theatre._(
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
      this.updatedAt,
      this.distance,
      this.thumbnail,
      this.cover})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Theatre', 'id');
    }
    if (location == null) {
      throw new BuiltValueNullFieldError('Theatre', 'location');
    }
    if (is_active == null) {
      throw new BuiltValueNullFieldError('Theatre', 'is_active');
    }
    if (rooms == null) {
      throw new BuiltValueNullFieldError('Theatre', 'rooms');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Theatre', 'name');
    }
    if (address == null) {
      throw new BuiltValueNullFieldError('Theatre', 'address');
    }
    if (phone_number == null) {
      throw new BuiltValueNullFieldError('Theatre', 'phone_number');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('Theatre', 'description');
    }
    if (opening_hours == null) {
      throw new BuiltValueNullFieldError('Theatre', 'opening_hours');
    }
    if (room_summary == null) {
      throw new BuiltValueNullFieldError('Theatre', 'room_summary');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Theatre', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('Theatre', 'updatedAt');
    }
    if (thumbnail == null) {
      throw new BuiltValueNullFieldError('Theatre', 'thumbnail');
    }
    if (cover == null) {
      throw new BuiltValueNullFieldError('Theatre', 'cover');
    }
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
  _$Theatre _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  LocationBuilder _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder location) => _$this._location = location;

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

  double _distance;
  double get distance => _$this._distance;
  set distance(double distance) => _$this._distance = distance;

  String _thumbnail;
  String get thumbnail => _$this._thumbnail;
  set thumbnail(String thumbnail) => _$this._thumbnail = thumbnail;

  String _cover;
  String get cover => _$this._cover;
  set cover(String cover) => _$this._cover = cover;

  TheatreBuilder();

  TheatreBuilder get _$this {
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
      _distance = _$v.distance;
      _thumbnail = _$v.thumbnail;
      _cover = _$v.cover;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Theatre other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Theatre;
  }

  @override
  void update(void Function(TheatreBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Theatre build() {
    _$Theatre _$result;
    try {
      _$result = _$v ??
          new _$Theatre._(
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
              updatedAt: updatedAt,
              distance: distance,
              thumbnail: thumbnail,
              cover: cover);
    } catch (_) {
      String _$failedField;
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
