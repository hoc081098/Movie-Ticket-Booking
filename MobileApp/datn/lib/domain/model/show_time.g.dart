// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_time.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ShowTime extends ShowTime {
  @override
  final String id;
  @override
  final bool is_active;
  @override
  final String movieId;
  @override
  final Movie movie;
  @override
  final String theatreId;
  @override
  final Theatre theatre;
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

  factory _$ShowTime([void Function(ShowTimeBuilder) updates]) =>
      (new ShowTimeBuilder()..update(updates)).build();

  _$ShowTime._(
      {this.id,
      this.is_active,
      this.movieId,
      this.movie,
      this.theatreId,
      this.theatre,
      this.room,
      this.end_time,
      this.start_time,
      this.createdAt,
      this.updatedAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'id');
    }
    if (is_active == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'is_active');
    }
    if (movieId == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'movieId');
    }
    if (theatreId == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'theatreId');
    }
    if (room == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'room');
    }
    if (end_time == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'end_time');
    }
    if (start_time == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'start_time');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('ShowTime', 'updatedAt');
    }
  }

  @override
  ShowTime rebuild(void Function(ShowTimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShowTimeBuilder toBuilder() => new ShowTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShowTime &&
        id == other.id &&
        is_active == other.is_active &&
        movieId == other.movieId &&
        movie == other.movie &&
        theatreId == other.theatreId &&
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
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, id.hashCode),
                                            is_active.hashCode),
                                        movieId.hashCode),
                                    movie.hashCode),
                                theatreId.hashCode),
                            theatre.hashCode),
                        room.hashCode),
                    end_time.hashCode),
                start_time.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ShowTime')
          ..add('id', id)
          ..add('is_active', is_active)
          ..add('movieId', movieId)
          ..add('movie', movie)
          ..add('theatreId', theatreId)
          ..add('theatre', theatre)
          ..add('room', room)
          ..add('end_time', end_time)
          ..add('start_time', start_time)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ShowTimeBuilder implements Builder<ShowTime, ShowTimeBuilder> {
  _$ShowTime _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  bool _is_active;
  bool get is_active => _$this._is_active;
  set is_active(bool is_active) => _$this._is_active = is_active;

  String _movieId;
  String get movieId => _$this._movieId;
  set movieId(String movieId) => _$this._movieId = movieId;

  MovieBuilder _movie;
  MovieBuilder get movie => _$this._movie ??= new MovieBuilder();
  set movie(MovieBuilder movie) => _$this._movie = movie;

  String _theatreId;
  String get theatreId => _$this._theatreId;
  set theatreId(String theatreId) => _$this._theatreId = theatreId;

  TheatreBuilder _theatre;
  TheatreBuilder get theatre => _$this._theatre ??= new TheatreBuilder();
  set theatre(TheatreBuilder theatre) => _$this._theatre = theatre;

  String _room;
  String get room => _$this._room;
  set room(String room) => _$this._room = room;

  DateTime _end_time;
  DateTime get end_time => _$this._end_time;
  set end_time(DateTime end_time) => _$this._end_time = end_time;

  DateTime _start_time;
  DateTime get start_time => _$this._start_time;
  set start_time(DateTime start_time) => _$this._start_time = start_time;

  DateTime _createdAt;
  DateTime get createdAt => _$this._createdAt;
  set createdAt(DateTime createdAt) => _$this._createdAt = createdAt;

  DateTime _updatedAt;
  DateTime get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime updatedAt) => _$this._updatedAt = updatedAt;

  ShowTimeBuilder();

  ShowTimeBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _is_active = _$v.is_active;
      _movieId = _$v.movieId;
      _movie = _$v.movie?.toBuilder();
      _theatreId = _$v.theatreId;
      _theatre = _$v.theatre?.toBuilder();
      _room = _$v.room;
      _end_time = _$v.end_time;
      _start_time = _$v.start_time;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShowTime other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ShowTime;
  }

  @override
  void update(void Function(ShowTimeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ShowTime build() {
    _$ShowTime _$result;
    try {
      _$result = _$v ??
          new _$ShowTime._(
              id: id,
              is_active: is_active,
              movieId: movieId,
              movie: _movie?.build(),
              theatreId: theatreId,
              theatre: _theatre?.build(),
              room: room,
              end_time: end_time,
              start_time: start_time,
              createdAt: createdAt,
              updatedAt: updatedAt);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'movie';
        _movie?.build();

        _$failedField = 'theatre';
        _theatre?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ShowTime', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
