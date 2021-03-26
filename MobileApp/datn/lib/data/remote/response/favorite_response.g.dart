// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FavoriteResponse> _$favoriteResponseSerializer =
    new _$FavoriteResponseSerializer();

class _$FavoriteResponseSerializer
    implements StructuredSerializer<FavoriteResponse> {
  @override
  final Iterable<Type> types = const [FavoriteResponse, _$FavoriteResponse];
  @override
  final String wireName = 'FavoriteResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, FavoriteResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'movie',
      serializers.serialize(object.movie,
          specifiedType: const FullType(MovieResponse)),
      'is_favorite',
      serializers.serialize(object.is_favorite,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  FavoriteResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FavoriteResponseBuilder();

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
        case 'is_favorite':
          result.is_favorite = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$FavoriteResponse extends FavoriteResponse {
  @override
  final MovieResponse movie;
  @override
  final bool is_favorite;

  factory _$FavoriteResponse(
          [void Function(FavoriteResponseBuilder)? updates]) =>
      (new FavoriteResponseBuilder()..update(updates)).build();

  _$FavoriteResponse._({required this.movie, required this.is_favorite})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(movie, 'FavoriteResponse', 'movie');
    BuiltValueNullFieldError.checkNotNull(
        is_favorite, 'FavoriteResponse', 'is_favorite');
  }

  @override
  FavoriteResponse rebuild(void Function(FavoriteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavoriteResponseBuilder toBuilder() =>
      new FavoriteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavoriteResponse &&
        movie == other.movie &&
        is_favorite == other.is_favorite;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, movie.hashCode), is_favorite.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FavoriteResponse')
          ..add('movie', movie)
          ..add('is_favorite', is_favorite))
        .toString();
  }
}

class FavoriteResponseBuilder
    implements Builder<FavoriteResponse, FavoriteResponseBuilder> {
  _$FavoriteResponse? _$v;

  MovieResponseBuilder? _movie;
  MovieResponseBuilder get movie =>
      _$this._movie ??= new MovieResponseBuilder();
  set movie(MovieResponseBuilder? movie) => _$this._movie = movie;

  bool? _is_favorite;
  bool? get is_favorite => _$this._is_favorite;
  set is_favorite(bool? is_favorite) => _$this._is_favorite = is_favorite;

  FavoriteResponseBuilder();

  FavoriteResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _movie = $v.movie.toBuilder();
      _is_favorite = $v.is_favorite;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FavoriteResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FavoriteResponse;
  }

  @override
  void update(void Function(FavoriteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FavoriteResponse build() {
    _$FavoriteResponse _$result;
    try {
      _$result = _$v ??
          new _$FavoriteResponse._(
              movie: movie.build(),
              is_favorite: BuiltValueNullFieldError.checkNotNull(
                  is_favorite, 'FavoriteResponse', 'is_favorite'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'movie';
        movie.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FavoriteResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
