// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MovieResponse> _$movieResponseSerializer =
    new _$MovieResponseSerializer();

class _$MovieResponseSerializer implements StructuredSerializer<MovieResponse> {
  @override
  final Iterable<Type> types = const [MovieResponse, _$MovieResponse];
  @override
  final String wireName = 'MovieResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, MovieResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'actors',
      serializers.serialize(object.actors,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'directors',
      serializers.serialize(object.directors,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'released_date',
      serializers.serialize(object.released_date,
          specifiedType: const FullType(DateTime)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(int)),
      'original_language',
      serializers.serialize(object.original_language,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
      'age_type',
      serializers.serialize(object.age_type,
          specifiedType: const FullType(String)),
      'rate_star',
      serializers.serialize(object.rate_star,
          specifiedType: const FullType(double)),
      'total_favorite',
      serializers.serialize(object.total_favorite,
          specifiedType: const FullType(int)),
      'total_rate',
      serializers.serialize(object.total_rate,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.is_active;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.trailer_video_url;
    if (value != null) {
      result
        ..add('trailer_video_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.poster_url;
    if (value != null) {
      result
        ..add('poster_url')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.overview;
    if (value != null) {
      result
        ..add('overview')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  MovieResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new MovieResponseBuilder();

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
        case 'actors':
          result.actors.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object>);
          break;
        case 'directors':
          result.directors.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object>);
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'trailer_video_url':
          result.trailer_video_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'poster_url':
          result.poster_url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'overview':
          result.overview = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'released_date':
          result.released_date = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'original_language':
          result.original_language = serializers.deserialize(value,
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
        case 'age_type':
          result.age_type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'rate_star':
          result.rate_star = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'total_favorite':
          result.total_favorite = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'total_rate':
          result.total_rate = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$MovieResponse extends MovieResponse {
  @override
  final String id;
  @override
  final bool? is_active;
  @override
  final BuiltList<String> actors;
  @override
  final BuiltList<String> directors;
  @override
  final String title;
  @override
  final String? trailer_video_url;
  @override
  final String? poster_url;
  @override
  final String? overview;
  @override
  final DateTime released_date;
  @override
  final int duration;
  @override
  final String original_language;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String age_type;
  @override
  final double rate_star;
  @override
  final int total_favorite;
  @override
  final int total_rate;

  factory _$MovieResponse([void Function(MovieResponseBuilder)? updates]) =>
      (new MovieResponseBuilder()..update(updates)).build();

  _$MovieResponse._(
      {required this.id,
      this.is_active,
      required this.actors,
      required this.directors,
      required this.title,
      this.trailer_video_url,
      this.poster_url,
      this.overview,
      required this.released_date,
      required this.duration,
      required this.original_language,
      required this.createdAt,
      required this.updatedAt,
      required this.age_type,
      required this.rate_star,
      required this.total_favorite,
      required this.total_rate})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'MovieResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(actors, 'MovieResponse', 'actors');
    BuiltValueNullFieldError.checkNotNull(
        directors, 'MovieResponse', 'directors');
    BuiltValueNullFieldError.checkNotNull(title, 'MovieResponse', 'title');
    BuiltValueNullFieldError.checkNotNull(
        released_date, 'MovieResponse', 'released_date');
    BuiltValueNullFieldError.checkNotNull(
        duration, 'MovieResponse', 'duration');
    BuiltValueNullFieldError.checkNotNull(
        original_language, 'MovieResponse', 'original_language');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'MovieResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'MovieResponse', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(
        age_type, 'MovieResponse', 'age_type');
    BuiltValueNullFieldError.checkNotNull(
        rate_star, 'MovieResponse', 'rate_star');
    BuiltValueNullFieldError.checkNotNull(
        total_favorite, 'MovieResponse', 'total_favorite');
    BuiltValueNullFieldError.checkNotNull(
        total_rate, 'MovieResponse', 'total_rate');
  }

  @override
  MovieResponse rebuild(void Function(MovieResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MovieResponseBuilder toBuilder() => new MovieResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MovieResponse &&
        id == other.id &&
        is_active == other.is_active &&
        actors == other.actors &&
        directors == other.directors &&
        title == other.title &&
        trailer_video_url == other.trailer_video_url &&
        poster_url == other.poster_url &&
        overview == other.overview &&
        released_date == other.released_date &&
        duration == other.duration &&
        original_language == other.original_language &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        age_type == other.age_type &&
        rate_star == other.rate_star &&
        total_favorite == other.total_favorite &&
        total_rate == other.total_rate;
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
                                                                    $jc(
                                                                        0,
                                                                        id
                                                                            .hashCode),
                                                                    is_active
                                                                        .hashCode),
                                                                actors
                                                                    .hashCode),
                                                            directors.hashCode),
                                                        title.hashCode),
                                                    trailer_video_url.hashCode),
                                                poster_url.hashCode),
                                            overview.hashCode),
                                        released_date.hashCode),
                                    duration.hashCode),
                                original_language.hashCode),
                            createdAt.hashCode),
                        updatedAt.hashCode),
                    age_type.hashCode),
                rate_star.hashCode),
            total_favorite.hashCode),
        total_rate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MovieResponse')
          ..add('id', id)
          ..add('is_active', is_active)
          ..add('actors', actors)
          ..add('directors', directors)
          ..add('title', title)
          ..add('trailer_video_url', trailer_video_url)
          ..add('poster_url', poster_url)
          ..add('overview', overview)
          ..add('released_date', released_date)
          ..add('duration', duration)
          ..add('original_language', original_language)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('age_type', age_type)
          ..add('rate_star', rate_star)
          ..add('total_favorite', total_favorite)
          ..add('total_rate', total_rate))
        .toString();
  }
}

class MovieResponseBuilder
    implements Builder<MovieResponse, MovieResponseBuilder> {
  _$MovieResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  ListBuilder<String>? _actors;
  ListBuilder<String> get actors =>
      _$this._actors ??= new ListBuilder<String>();
  set actors(ListBuilder<String>? actors) => _$this._actors = actors;

  ListBuilder<String>? _directors;
  ListBuilder<String> get directors =>
      _$this._directors ??= new ListBuilder<String>();
  set directors(ListBuilder<String>? directors) =>
      _$this._directors = directors;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _trailer_video_url;
  String? get trailer_video_url => _$this._trailer_video_url;
  set trailer_video_url(String? trailer_video_url) =>
      _$this._trailer_video_url = trailer_video_url;

  String? _poster_url;
  String? get poster_url => _$this._poster_url;
  set poster_url(String? poster_url) => _$this._poster_url = poster_url;

  String? _overview;
  String? get overview => _$this._overview;
  set overview(String? overview) => _$this._overview = overview;

  DateTime? _released_date;
  DateTime? get released_date => _$this._released_date;
  set released_date(DateTime? released_date) =>
      _$this._released_date = released_date;

  int? _duration;
  int? get duration => _$this._duration;
  set duration(int? duration) => _$this._duration = duration;

  String? _original_language;
  String? get original_language => _$this._original_language;
  set original_language(String? original_language) =>
      _$this._original_language = original_language;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _age_type;
  String? get age_type => _$this._age_type;
  set age_type(String? age_type) => _$this._age_type = age_type;

  double? _rate_star;
  double? get rate_star => _$this._rate_star;
  set rate_star(double? rate_star) => _$this._rate_star = rate_star;

  int? _total_favorite;
  int? get total_favorite => _$this._total_favorite;
  set total_favorite(int? total_favorite) =>
      _$this._total_favorite = total_favorite;

  int? _total_rate;
  int? get total_rate => _$this._total_rate;
  set total_rate(int? total_rate) => _$this._total_rate = total_rate;

  MovieResponseBuilder();

  MovieResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _is_active = $v.is_active;
      _actors = $v.actors.toBuilder();
      _directors = $v.directors.toBuilder();
      _title = $v.title;
      _trailer_video_url = $v.trailer_video_url;
      _poster_url = $v.poster_url;
      _overview = $v.overview;
      _released_date = $v.released_date;
      _duration = $v.duration;
      _original_language = $v.original_language;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _age_type = $v.age_type;
      _rate_star = $v.rate_star;
      _total_favorite = $v.total_favorite;
      _total_rate = $v.total_rate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MovieResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MovieResponse;
  }

  @override
  void update(void Function(MovieResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MovieResponse build() {
    _$MovieResponse _$result;
    try {
      _$result = _$v ??
          new _$MovieResponse._(
              id: BuiltValueNullFieldError.checkNotNull(
                  id, 'MovieResponse', 'id'),
              is_active: is_active,
              actors: actors.build(),
              directors: directors.build(),
              title: BuiltValueNullFieldError.checkNotNull(
                  title, 'MovieResponse', 'title'),
              trailer_video_url: trailer_video_url,
              poster_url: poster_url,
              overview: overview,
              released_date: BuiltValueNullFieldError.checkNotNull(
                  released_date, 'MovieResponse', 'released_date'),
              duration: BuiltValueNullFieldError.checkNotNull(
                  duration, 'MovieResponse', 'duration'),
              original_language: BuiltValueNullFieldError.checkNotNull(
                  original_language, 'MovieResponse', 'original_language'),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'MovieResponse', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'MovieResponse', 'updatedAt'),
              age_type: BuiltValueNullFieldError.checkNotNull(
                  age_type, 'MovieResponse', 'age_type'),
              rate_star: BuiltValueNullFieldError.checkNotNull(
                  rate_star, 'MovieResponse', 'rate_star'),
              total_favorite: BuiltValueNullFieldError.checkNotNull(total_favorite, 'MovieResponse', 'total_favorite'),
              total_rate: BuiltValueNullFieldError.checkNotNull(total_rate, 'MovieResponse', 'total_rate'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'actors';
        actors.build();
        _$failedField = 'directors';
        directors.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MovieResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
