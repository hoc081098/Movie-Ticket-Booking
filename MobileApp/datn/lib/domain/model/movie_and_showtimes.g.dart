// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_and_showtimes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MovieAndShowTimes extends MovieAndShowTimes {
  @override
  final Movie movie;
  @override
  final BuiltList<ShowTime> showTimes;

  factory _$MovieAndShowTimes(
          [void Function(MovieAndShowTimesBuilder)? updates]) =>
      (new MovieAndShowTimesBuilder()..update(updates)).build();

  _$MovieAndShowTimes._({required this.movie, required this.showTimes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(movie, 'MovieAndShowTimes', 'movie');
    BuiltValueNullFieldError.checkNotNull(
        showTimes, 'MovieAndShowTimes', 'showTimes');
  }

  @override
  MovieAndShowTimes rebuild(void Function(MovieAndShowTimesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MovieAndShowTimesBuilder toBuilder() =>
      new MovieAndShowTimesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MovieAndShowTimes &&
        movie == other.movie &&
        showTimes == other.showTimes;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, movie.hashCode), showTimes.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MovieAndShowTimes')
          ..add('movie', movie)
          ..add('showTimes', showTimes))
        .toString();
  }
}

class MovieAndShowTimesBuilder
    implements Builder<MovieAndShowTimes, MovieAndShowTimesBuilder> {
  _$MovieAndShowTimes? _$v;

  MovieBuilder? _movie;
  MovieBuilder get movie => _$this._movie ??= new MovieBuilder();
  set movie(MovieBuilder? movie) => _$this._movie = movie;

  ListBuilder<ShowTime>? _showTimes;
  ListBuilder<ShowTime> get showTimes =>
      _$this._showTimes ??= new ListBuilder<ShowTime>();
  set showTimes(ListBuilder<ShowTime>? showTimes) =>
      _$this._showTimes = showTimes;

  MovieAndShowTimesBuilder();

  MovieAndShowTimesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _movie = $v.movie.toBuilder();
      _showTimes = $v.showTimes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MovieAndShowTimes other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MovieAndShowTimes;
  }

  @override
  void update(void Function(MovieAndShowTimesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MovieAndShowTimes build() {
    _$MovieAndShowTimes _$result;
    try {
      _$result = _$v ??
          new _$MovieAndShowTimes._(
              movie: movie.build(), showTimes: showTimes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'movie';
        movie.build();
        _$failedField = 'showTimes';
        showTimes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MovieAndShowTimes', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
