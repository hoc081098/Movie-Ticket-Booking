// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CommentsResponse> _$commentsResponseSerializer =
    new _$CommentsResponseSerializer();

class _$CommentsResponseSerializer
    implements StructuredSerializer<CommentsResponse> {
  @override
  final Iterable<Type> types = const [CommentsResponse, _$CommentsResponse];
  @override
  final String wireName = 'CommentsResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, CommentsResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'comments',
      serializers.serialize(object.comments,
          specifiedType: const FullType(
              BuiltList, const [const FullType(CommentResponse)])),
      'average',
      serializers.serialize(object.average,
          specifiedType: const FullType(double)),
      'total',
      serializers.serialize(object.total, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  CommentsResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CommentsResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'comments':
          result.comments.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(CommentResponse)]))!
              as BuiltList<Object>);
          break;
        case 'average':
          result.average = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'total':
          result.total = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$CommentsResponse extends CommentsResponse {
  @override
  final BuiltList<CommentResponse> comments;
  @override
  final double average;
  @override
  final int total;

  factory _$CommentsResponse(
          [void Function(CommentsResponseBuilder)? updates]) =>
      (new CommentsResponseBuilder()..update(updates)).build();

  _$CommentsResponse._(
      {required this.comments, required this.average, required this.total})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        comments, 'CommentsResponse', 'comments');
    BuiltValueNullFieldError.checkNotNull(
        average, 'CommentsResponse', 'average');
    BuiltValueNullFieldError.checkNotNull(total, 'CommentsResponse', 'total');
  }

  @override
  CommentsResponse rebuild(void Function(CommentsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentsResponseBuilder toBuilder() =>
      new CommentsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommentsResponse &&
        comments == other.comments &&
        average == other.average &&
        total == other.total;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, comments.hashCode), average.hashCode), total.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CommentsResponse')
          ..add('comments', comments)
          ..add('average', average)
          ..add('total', total))
        .toString();
  }
}

class CommentsResponseBuilder
    implements Builder<CommentsResponse, CommentsResponseBuilder> {
  _$CommentsResponse? _$v;

  ListBuilder<CommentResponse>? _comments;
  ListBuilder<CommentResponse> get comments =>
      _$this._comments ??= new ListBuilder<CommentResponse>();
  set comments(ListBuilder<CommentResponse>? comments) =>
      _$this._comments = comments;

  double? _average;
  double? get average => _$this._average;
  set average(double? average) => _$this._average = average;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  CommentsResponseBuilder();

  CommentsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _comments = $v.comments.toBuilder();
      _average = $v.average;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommentsResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CommentsResponse;
  }

  @override
  void update(void Function(CommentsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CommentsResponse build() {
    _$CommentsResponse _$result;
    try {
      _$result = _$v ??
          new _$CommentsResponse._(
              comments: comments.build(),
              average: BuiltValueNullFieldError.checkNotNull(
                  average, 'CommentsResponse', 'average'),
              total: BuiltValueNullFieldError.checkNotNull(
                  total, 'CommentsResponse', 'total'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'comments';
        comments.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CommentsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
