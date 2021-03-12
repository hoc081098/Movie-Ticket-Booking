// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_time_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ShowTimeResponse> _$showTimeResponseSerializer =
    new _$ShowTimeResponseSerializer();

class _$ShowTimeResponseSerializer
    implements StructuredSerializer<ShowTimeResponse> {
  @override
  final Iterable<Type> types = const [ShowTimeResponse, _$ShowTimeResponse];
  @override
  final String wireName = 'ShowTimeResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, ShowTimeResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'movie',
      serializers.serialize(object.movie,
          specifiedType: const FullType(String)),
      'theatre',
      serializers.serialize(object.theatre,
          specifiedType: const FullType(String)),
      'room',
      serializers.serialize(object.room, specifiedType: const FullType(String)),
      'end_time',
      serializers.serialize(object.end_time,
          specifiedType: const FullType(DateTime)),
      'start_time',
      serializers.serialize(object.start_time,
          specifiedType: const FullType(DateTime)),
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
    return result;
  }

  @override
  ShowTimeResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShowTimeResponseBuilder();

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
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'movie':
          result.movie = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'theatre':
          result.theatre = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'room':
          result.room = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'end_time':
          result.end_time = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'start_time':
          result.start_time = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
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

class _$ShowTimeResponse extends ShowTimeResponse {
  @override
  final String id;
  @override
  final bool? is_active;
  @override
  final String movie;
  @override
  final String theatre;
  @override
  final String room;
  @override
  final DateTime end_time;
  @override
  final DateTime start_time;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$ShowTimeResponse(
          [void Function(ShowTimeResponseBuilder)? updates]) =>
      (new ShowTimeResponseBuilder()..update(updates)).build();

  _$ShowTimeResponse._(
      {required this.id,
      this.is_active,
      required this.movie,
      required this.theatre,
      required this.room,
      required this.end_time,
      required this.start_time,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'ShowTimeResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(movie, 'ShowTimeResponse', 'movie');
    BuiltValueNullFieldError.checkNotNull(
        theatre, 'ShowTimeResponse', 'theatre');
    BuiltValueNullFieldError.checkNotNull(room, 'ShowTimeResponse', 'room');
    BuiltValueNullFieldError.checkNotNull(
        end_time, 'ShowTimeResponse', 'end_time');
    BuiltValueNullFieldError.checkNotNull(
        start_time, 'ShowTimeResponse', 'start_time');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'ShowTimeResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'ShowTimeResponse', 'updatedAt');
  }

  @override
  ShowTimeResponse rebuild(void Function(ShowTimeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShowTimeResponseBuilder toBuilder() =>
      new ShowTimeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShowTimeResponse &&
        id == other.id &&
        is_active == other.is_active &&
        movie == other.movie &&
        theatre == other.theatre &&
        room == other.room &&
        end_time == other.end_time &&
        start_time == other.start_time &&
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
                            $jc($jc($jc(0, id.hashCode), is_active.hashCode),
                                movie.hashCode),
                            theatre.hashCode),
                        room.hashCode),
                    end_time.hashCode),
                start_time.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ShowTimeResponse')
          ..add('id', id)
          ..add('is_active', is_active)
          ..add('movie', movie)
          ..add('theatre', theatre)
          ..add('room', room)
          ..add('end_time', end_time)
          ..add('start_time', start_time)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ShowTimeResponseBuilder
    implements Builder<ShowTimeResponse, ShowTimeResponseBuilder> {
  _$ShowTimeResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  String? _movie;
  String? get movie => _$this._movie;
  set movie(String? movie) => _$this._movie = movie;

  String? _theatre;
  String? get theatre => _$this._theatre;
  set theatre(String? theatre) => _$this._theatre = theatre;

  String? _room;
  String? get room => _$this._room;
  set room(String? room) => _$this._room = room;

  DateTime? _end_time;
  DateTime? get end_time => _$this._end_time;
  set end_time(DateTime? end_time) => _$this._end_time = end_time;

  DateTime? _start_time;
  DateTime? get start_time => _$this._start_time;
  set start_time(DateTime? start_time) => _$this._start_time = start_time;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ShowTimeResponseBuilder();

  ShowTimeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _is_active = $v.is_active;
      _movie = $v.movie;
      _theatre = $v.theatre;
      _room = $v.room;
      _end_time = $v.end_time;
      _start_time = $v.start_time;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShowTimeResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShowTimeResponse;
  }

  @override
  void update(void Function(ShowTimeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ShowTimeResponse build() {
    final _$result = _$v ??
        new _$ShowTimeResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'ShowTimeResponse', 'id'),
            is_active: is_active,
            movie: BuiltValueNullFieldError.checkNotNull(
                movie, 'ShowTimeResponse', 'movie'),
            theatre: BuiltValueNullFieldError.checkNotNull(
                theatre, 'ShowTimeResponse', 'theatre'),
            room: BuiltValueNullFieldError.checkNotNull(
                room, 'ShowTimeResponse', 'room'),
            end_time: BuiltValueNullFieldError.checkNotNull(
                end_time, 'ShowTimeResponse', 'end_time'),
            start_time: BuiltValueNullFieldError.checkNotNull(
                start_time, 'ShowTimeResponse', 'start_time'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, 'ShowTimeResponse', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, 'ShowTimeResponse', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
