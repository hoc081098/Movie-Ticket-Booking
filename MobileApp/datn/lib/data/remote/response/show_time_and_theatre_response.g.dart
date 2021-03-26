// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_time_and_theatre_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ShowTimeAndTheatreResponse> _$showTimeAndTheatreResponseSerializer =
    new _$ShowTimeAndTheatreResponseSerializer();

class _$ShowTimeAndTheatreResponseSerializer
    implements StructuredSerializer<ShowTimeAndTheatreResponse> {
  @override
  final Iterable<Type> types = const [
    ShowTimeAndTheatreResponse,
    _$ShowTimeAndTheatreResponse
  ];
  @override
  final String wireName = 'ShowTimeAndTheatreResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, ShowTimeAndTheatreResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'show_time',
      serializers.serialize(object.show_time,
          specifiedType: const FullType(ShowTimeResponse)),
      'theatre',
      serializers.serialize(object.theatre,
          specifiedType: const FullType(TheatreResponse)),
    ];

    return result;
  }

  @override
  ShowTimeAndTheatreResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ShowTimeAndTheatreResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'show_time':
          result.show_time.replace(serializers.deserialize(value,
                  specifiedType: const FullType(ShowTimeResponse))!
              as ShowTimeResponse);
          break;
        case 'theatre':
          result.theatre.replace(serializers.deserialize(value,
                  specifiedType: const FullType(TheatreResponse))!
              as TheatreResponse);
          break;
      }
    }

    return result.build();
  }
}

class _$ShowTimeAndTheatreResponse extends ShowTimeAndTheatreResponse {
  @override
  final ShowTimeResponse show_time;
  @override
  final TheatreResponse theatre;

  factory _$ShowTimeAndTheatreResponse(
          [void Function(ShowTimeAndTheatreResponseBuilder)? updates]) =>
      (new ShowTimeAndTheatreResponseBuilder()..update(updates)).build();

  _$ShowTimeAndTheatreResponse._(
      {required this.show_time, required this.theatre})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        show_time, 'ShowTimeAndTheatreResponse', 'show_time');
    BuiltValueNullFieldError.checkNotNull(
        theatre, 'ShowTimeAndTheatreResponse', 'theatre');
  }

  @override
  ShowTimeAndTheatreResponse rebuild(
          void Function(ShowTimeAndTheatreResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShowTimeAndTheatreResponseBuilder toBuilder() =>
      new ShowTimeAndTheatreResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShowTimeAndTheatreResponse &&
        show_time == other.show_time &&
        theatre == other.theatre;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, show_time.hashCode), theatre.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ShowTimeAndTheatreResponse')
          ..add('show_time', show_time)
          ..add('theatre', theatre))
        .toString();
  }
}

class ShowTimeAndTheatreResponseBuilder
    implements
        Builder<ShowTimeAndTheatreResponse, ShowTimeAndTheatreResponseBuilder> {
  _$ShowTimeAndTheatreResponse? _$v;

  ShowTimeResponseBuilder? _show_time;
  ShowTimeResponseBuilder get show_time =>
      _$this._show_time ??= new ShowTimeResponseBuilder();
  set show_time(ShowTimeResponseBuilder? show_time) =>
      _$this._show_time = show_time;

  TheatreResponseBuilder? _theatre;
  TheatreResponseBuilder get theatre =>
      _$this._theatre ??= new TheatreResponseBuilder();
  set theatre(TheatreResponseBuilder? theatre) => _$this._theatre = theatre;

  ShowTimeAndTheatreResponseBuilder();

  ShowTimeAndTheatreResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _show_time = $v.show_time.toBuilder();
      _theatre = $v.theatre.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShowTimeAndTheatreResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ShowTimeAndTheatreResponse;
  }

  @override
  void update(void Function(ShowTimeAndTheatreResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ShowTimeAndTheatreResponse build() {
    _$ShowTimeAndTheatreResponse _$result;
    try {
      _$result = _$v ??
          new _$ShowTimeAndTheatreResponse._(
              show_time: show_time.build(), theatre: theatre.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'show_time';
        show_time.build();
        _$failedField = 'theatre';
        theatre.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ShowTimeAndTheatreResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
