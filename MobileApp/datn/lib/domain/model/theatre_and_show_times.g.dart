// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theatre_and_show_times.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TheatreAndShowTimes extends TheatreAndShowTimes {
  @override
  final Theatre theatre;
  @override
  final BuiltList<ShowTime> showTimes;

  factory _$TheatreAndShowTimes(
          [void Function(TheatreAndShowTimesBuilder)? updates]) =>
      (new TheatreAndShowTimesBuilder()..update(updates)).build();

  _$TheatreAndShowTimes._({required this.theatre, required this.showTimes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        theatre, 'TheatreAndShowTimes', 'theatre');
    BuiltValueNullFieldError.checkNotNull(
        showTimes, 'TheatreAndShowTimes', 'showTimes');
  }

  @override
  TheatreAndShowTimes rebuild(
          void Function(TheatreAndShowTimesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TheatreAndShowTimesBuilder toBuilder() =>
      new TheatreAndShowTimesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TheatreAndShowTimes &&
        theatre == other.theatre &&
        showTimes == other.showTimes;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, theatre.hashCode), showTimes.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TheatreAndShowTimes')
          ..add('theatre', theatre)
          ..add('showTimes', showTimes))
        .toString();
  }
}

class TheatreAndShowTimesBuilder
    implements Builder<TheatreAndShowTimes, TheatreAndShowTimesBuilder> {
  _$TheatreAndShowTimes? _$v;

  TheatreBuilder? _theatre;
  TheatreBuilder get theatre => _$this._theatre ??= new TheatreBuilder();
  set theatre(TheatreBuilder? theatre) => _$this._theatre = theatre;

  ListBuilder<ShowTime>? _showTimes;
  ListBuilder<ShowTime> get showTimes =>
      _$this._showTimes ??= new ListBuilder<ShowTime>();
  set showTimes(ListBuilder<ShowTime>? showTimes) =>
      _$this._showTimes = showTimes;

  TheatreAndShowTimesBuilder();

  TheatreAndShowTimesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _theatre = $v.theatre.toBuilder();
      _showTimes = $v.showTimes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TheatreAndShowTimes other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TheatreAndShowTimes;
  }

  @override
  void update(void Function(TheatreAndShowTimesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TheatreAndShowTimes build() {
    _$TheatreAndShowTimes _$result;
    try {
      _$result = _$v ??
          new _$TheatreAndShowTimes._(
              theatre: theatre.build(), showTimes: showTimes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'theatre';
        theatre.build();
        _$failedField = 'showTimes';
        showTimes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TheatreAndShowTimes', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
