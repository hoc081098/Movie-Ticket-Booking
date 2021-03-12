// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SeatCoordinates extends SeatCoordinates {
  @override
  final int x;
  @override
  final int y;

  factory _$SeatCoordinates([void Function(SeatCoordinatesBuilder)? updates]) =>
      (new SeatCoordinatesBuilder()..update(updates)).build();

  _$SeatCoordinates._({required this.x, required this.y}) : super._() {
    BuiltValueNullFieldError.checkNotNull(x, 'SeatCoordinates', 'x');
    BuiltValueNullFieldError.checkNotNull(y, 'SeatCoordinates', 'y');
  }

  @override
  SeatCoordinates rebuild(void Function(SeatCoordinatesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeatCoordinatesBuilder toBuilder() =>
      new SeatCoordinatesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SeatCoordinates && x == other.x && y == other.y;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, x.hashCode), y.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SeatCoordinates')
          ..add('x', x)
          ..add('y', y))
        .toString();
  }
}

class SeatCoordinatesBuilder
    implements Builder<SeatCoordinates, SeatCoordinatesBuilder> {
  _$SeatCoordinates? _$v;

  int? _x;
  int? get x => _$this._x;
  set x(int? x) => _$this._x = x;

  int? _y;
  int? get y => _$this._y;
  set y(int? y) => _$this._y = y;

  SeatCoordinatesBuilder();

  SeatCoordinatesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _x = $v.x;
      _y = $v.y;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SeatCoordinates other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SeatCoordinates;
  }

  @override
  void update(void Function(SeatCoordinatesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SeatCoordinates build() {
    final _$result = _$v ??
        new _$SeatCoordinates._(
            x: BuiltValueNullFieldError.checkNotNull(x, 'SeatCoordinates', 'x'),
            y: BuiltValueNullFieldError.checkNotNull(
                y, 'SeatCoordinates', 'y'));
    replace(_$result);
    return _$result;
  }
}

class _$Seat extends Seat {
  @override
  final bool is_active;
  @override
  final SeatCoordinates coordinates;
  @override
  final String id;
  @override
  final String room;
  @override
  final String theatre;
  @override
  final int column;
  @override
  final String row;
  @override
  final int count;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$Seat([void Function(SeatBuilder)? updates]) =>
      (new SeatBuilder()..update(updates)).build();

  _$Seat._(
      {required this.is_active,
      required this.coordinates,
      required this.id,
      required this.room,
      required this.theatre,
      required this.column,
      required this.row,
      required this.count,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(is_active, 'Seat', 'is_active');
    BuiltValueNullFieldError.checkNotNull(coordinates, 'Seat', 'coordinates');
    BuiltValueNullFieldError.checkNotNull(id, 'Seat', 'id');
    BuiltValueNullFieldError.checkNotNull(room, 'Seat', 'room');
    BuiltValueNullFieldError.checkNotNull(theatre, 'Seat', 'theatre');
    BuiltValueNullFieldError.checkNotNull(column, 'Seat', 'column');
    BuiltValueNullFieldError.checkNotNull(row, 'Seat', 'row');
    BuiltValueNullFieldError.checkNotNull(count, 'Seat', 'count');
    BuiltValueNullFieldError.checkNotNull(createdAt, 'Seat', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, 'Seat', 'updatedAt');
  }

  @override
  Seat rebuild(void Function(SeatBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SeatBuilder toBuilder() => new SeatBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Seat &&
        is_active == other.is_active &&
        coordinates == other.coordinates &&
        id == other.id &&
        room == other.room &&
        theatre == other.theatre &&
        column == other.column &&
        row == other.row &&
        count == other.count &&
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
                                    $jc($jc(0, is_active.hashCode),
                                        coordinates.hashCode),
                                    id.hashCode),
                                room.hashCode),
                            theatre.hashCode),
                        column.hashCode),
                    row.hashCode),
                count.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Seat')
          ..add('is_active', is_active)
          ..add('coordinates', coordinates)
          ..add('id', id)
          ..add('room', room)
          ..add('theatre', theatre)
          ..add('column', column)
          ..add('row', row)
          ..add('count', count)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class SeatBuilder implements Builder<Seat, SeatBuilder> {
  _$Seat? _$v;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  SeatCoordinatesBuilder? _coordinates;
  SeatCoordinatesBuilder get coordinates =>
      _$this._coordinates ??= new SeatCoordinatesBuilder();
  set coordinates(SeatCoordinatesBuilder? coordinates) =>
      _$this._coordinates = coordinates;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _room;
  String? get room => _$this._room;
  set room(String? room) => _$this._room = room;

  String? _theatre;
  String? get theatre => _$this._theatre;
  set theatre(String? theatre) => _$this._theatre = theatre;

  int? _column;
  int? get column => _$this._column;
  set column(int? column) => _$this._column = column;

  String? _row;
  String? get row => _$this._row;
  set row(String? row) => _$this._row = row;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  SeatBuilder();

  SeatBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _is_active = $v.is_active;
      _coordinates = $v.coordinates.toBuilder();
      _id = $v.id;
      _room = $v.room;
      _theatre = $v.theatre;
      _column = $v.column;
      _row = $v.row;
      _count = $v.count;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Seat other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Seat;
  }

  @override
  void update(void Function(SeatBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Seat build() {
    _$Seat _$result;
    try {
      _$result = _$v ??
          new _$Seat._(
              is_active: BuiltValueNullFieldError.checkNotNull(
                  is_active, 'Seat', 'is_active'),
              coordinates: coordinates.build(),
              id: BuiltValueNullFieldError.checkNotNull(id, 'Seat', 'id'),
              room: BuiltValueNullFieldError.checkNotNull(room, 'Seat', 'room'),
              theatre: BuiltValueNullFieldError.checkNotNull(
                  theatre, 'Seat', 'theatre'),
              column: BuiltValueNullFieldError.checkNotNull(
                  column, 'Seat', 'column'),
              row: BuiltValueNullFieldError.checkNotNull(row, 'Seat', 'row'),
              count:
                  BuiltValueNullFieldError.checkNotNull(count, 'Seat', 'count'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'Seat', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'Seat', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'coordinates';
        coordinates.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Seat', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
