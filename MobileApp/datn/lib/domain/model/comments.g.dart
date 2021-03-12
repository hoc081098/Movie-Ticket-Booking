// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Comments extends Comments {
  @override
  final BuiltList<Comment> comments;
  @override
  final double average;
  @override
  final int total;

  factory _$Comments([void Function(CommentsBuilder)? updates]) =>
      (new CommentsBuilder()..update(updates)).build();

  _$Comments._(
      {required this.comments, required this.average, required this.total})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(comments, 'Comments', 'comments');
    BuiltValueNullFieldError.checkNotNull(average, 'Comments', 'average');
    BuiltValueNullFieldError.checkNotNull(total, 'Comments', 'total');
  }

  @override
  Comments rebuild(void Function(CommentsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentsBuilder toBuilder() => new CommentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Comments &&
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
    return (newBuiltValueToStringHelper('Comments')
          ..add('comments', comments)
          ..add('average', average)
          ..add('total', total))
        .toString();
  }
}

class CommentsBuilder implements Builder<Comments, CommentsBuilder> {
  _$Comments? _$v;

  ListBuilder<Comment>? _comments;
  ListBuilder<Comment> get comments =>
      _$this._comments ??= new ListBuilder<Comment>();
  set comments(ListBuilder<Comment>? comments) => _$this._comments = comments;

  double? _average;
  double? get average => _$this._average;
  set average(double? average) => _$this._average = average;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  CommentsBuilder();

  CommentsBuilder get _$this {
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
  void replace(Comments other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Comments;
  }

  @override
  void update(void Function(CommentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Comments build() {
    _$Comments _$result;
    try {
      _$result = _$v ??
          new _$Comments._(
              comments: comments.build(),
              average: BuiltValueNullFieldError.checkNotNull(
                  average, 'Comments', 'average'),
              total: BuiltValueNullFieldError.checkNotNull(
                  total, 'Comments', 'total'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'comments';
        comments.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Comments', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
