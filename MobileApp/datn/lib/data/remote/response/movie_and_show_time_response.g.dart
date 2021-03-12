// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_and_show_time_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MovieAndShowTimeResponse> _$movieAndShowTimeResponseSerializer =
    new _$MovieAndShowTimeResponseSerializer();

class _$MovieAndShowTimeResponseSerializer
    implements StructuredSerializer<MovieAndShowTimeResponse> {
  @override
  final Iterable<Type> types = const [
    MovieAndShowTimeResponse,
    _$MovieAndShowTimeResponse
  ];
  @override
  final String wireName = 'MovieAndShowTimeResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, MovieAndShowTimeResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'movie',
      serializers.serialize(object.movie,
          specifiedType: const FullType(MovieResponse)),
      'show_time',
      serializers.serialize(object.show_time,
          specifiedType: const FullType(ShowTimeResponse)),
    ];

    return result;
  }

  @override
  MovieAndShowTimeResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MovieAndShowTimeResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'movie':
          result.movie.replace(serializers.deserialize(value,
              specifiedType: const FullType(MovieResponse))! as MovieResponse);
          break;
        case 'show_time':
          result.show_time.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShowTimeResponse))!
              as ShowTimeResponse);
          break;
      }
    }

    return result.build();
  }
}

class _$MovieAndShowTimeResponse extends MovieAndShowTimeResponse {
  @override
  final MovieResponse movie;
  @override
  final ShowTimeResponse show_time;

  factory _$MovieAndShowTimeResponse(
          [void Function(MovieAndShowTimeResponseBuilder)? updates]) =>
      (new MovieAndShowTimeResponseBuilder()..update(updates)).build();

  _$MovieAndShowTimeResponse._({required this.movie, required this.show_time})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        movie, 'MovieAndShowTimeResponse', 'movie');
    BuiltValueNullFieldError.checkNotNull(
        show_time, 'MovieAndShowTimeResponse', 'show_time');
  }

  @override
  MovieAndShowTimeResponse rebuild(
          void Function(MovieAndShowTimeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MovieAndShowTimeResponseBuilder toBuilder() =>
      new MovieAndShowTimeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MovieAndShowTimeResponse &&
        movie == other.movie &&
        show_time == other.show_time;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, movie.hashCode), show_time.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MovieAndShowTimeResponse')
          ..add('movie', movie)
          ..add('show_time', show_time))
        .toString();
  }
}

class MovieAndShowTimeResponseBuilder
    implements
        Builder<MovieAndShowTimeResponse, MovieAndShowTimeResponseBuilder> {
  _$MovieAndShowTimeResponse? _$v;

  MovieResponseBuilder? _movie;
  MovieResponseBuilder get movie =>
      _$this._movie ??= new MovieResponseBuilder();
  set movie(MovieResponseBuilder? movie) => _$this._movie = movie;

  ShowTimeResponseBuilder? _show_time;
  ShowTimeResponseBuilder get show_time =>
      _$this._show_time ??= new ShowTimeResponseBuilder();
  set show_time(ShowTimeResponseBuilder? show_time) =>
      _$this._show_time = show_time;

  MovieAndShowTimeResponseBuilder();

  MovieAndShowTimeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _movie = $v.movie.toBuilder();
      _show_time = $v.show_time.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MovieAndShowTimeResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MovieAndShowTimeResponse;
  }

  @override
  void update(void Function(MovieAndShowTimeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MovieAndShowTimeResponse build() {
    _$MovieAndShowTimeResponse _$result;
    try {
      _$result = _$v ??
          new _$MovieAndShowTimeResponse._(
              movie: movie.build(), show_time: show_time.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'movie';
        movie.build();
        _$failedField = 'show_time';
        show_time.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MovieAndShowTimeResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
