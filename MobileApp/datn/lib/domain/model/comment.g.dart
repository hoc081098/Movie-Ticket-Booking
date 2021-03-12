// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Comment extends Comment {
  @override
  final String id;
  @override
  final bool is_active;
  @override
  final String content;
  @override
  final int rate_star;
  @override
  final String movie;
  @override
  final User user;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$Comment([void Function(CommentBuilder)? updates]) =>
      (new CommentBuilder()..update(updates)).build();

  _$Comment._(
      {required this.id,
      required this.is_active,
      required this.content,
      required this.rate_star,
      required this.movie,
      required this.user,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Comment', 'id');
    BuiltValueNullFieldError.checkNotNull(is_active, 'Comment', 'is_active');
    BuiltValueNullFieldError.checkNotNull(content, 'Comment', 'content');
    BuiltValueNullFieldError.checkNotNull(rate_star, 'Comment', 'rate_star');
    BuiltValueNullFieldError.checkNotNull(movie, 'Comment', 'movie');
    BuiltValueNullFieldError.checkNotNull(user, 'Comment', 'user');
    BuiltValueNullFieldError.checkNotNull(createdAt, 'Comment', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, 'Comment', 'updatedAt');
  }

  @override
  Comment rebuild(void Function(CommentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommentBuilder toBuilder() => new CommentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Comment &&
        id == other.id &&
        is_active == other.is_active &&
        content == other.content &&
        rate_star == other.rate_star &&
        movie == other.movie &&
        user == other.user &&
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
                        $jc($jc($jc(0, id.hashCode), is_active.hashCode),
                            content.hashCode),
                        rate_star.hashCode),
                    movie.hashCode),
                user.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Comment')
          ..add('id', id)
          ..add('is_active', is_active)
          ..add('content', content)
          ..add('rate_star', rate_star)
          ..add('movie', movie)
          ..add('user', user)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class CommentBuilder implements Builder<Comment, CommentBuilder> {
  _$Comment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  int? _rate_star;
  int? get rate_star => _$this._rate_star;
  set rate_star(int? rate_star) => _$this._rate_star = rate_star;

  String? _movie;
  String? get movie => _$this._movie;
  set movie(String? movie) => _$this._movie = movie;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  CommentBuilder();

  CommentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _is_active = $v.is_active;
      _content = $v.content;
      _rate_star = $v.rate_star;
      _movie = $v.movie;
      _user = $v.user.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Comment other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Comment;
  }

  @override
  void update(void Function(CommentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Comment build() {
    _$Comment _$result;
    try {
      _$result = _$v ??
          new _$Comment._(
              id: BuiltValueNullFieldError.checkNotNull(id, 'Comment', 'id'),
              is_active: BuiltValueNullFieldError.checkNotNull(
                  is_active, 'Comment', 'is_active'),
              content: BuiltValueNullFieldError.checkNotNull(
                  content, 'Comment', 'content'),
              rate_star: BuiltValueNullFieldError.checkNotNull(
                  rate_star, 'Comment', 'rate_star'),
              movie: BuiltValueNullFieldError.checkNotNull(
                  movie, 'Comment', 'movie'),
              user: user.build(),
              createdAt: BuiltValueNullFieldError.checkNotNull(
                  createdAt, 'Comment', 'createdAt'),
              updatedAt: BuiltValueNullFieldError.checkNotNull(
                  updatedAt, 'Comment', 'updatedAt'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Comment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
