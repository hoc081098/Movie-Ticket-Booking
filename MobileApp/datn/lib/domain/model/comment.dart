import 'package:built_value/built_value.dart';

import 'user.dart';

part 'comment.g.dart';

abstract class Comment implements Built<Comment, CommentBuilder> {
  String get id;

  bool get is_active;

  String get content;

  int get rate_star;

  String get movie;

  User get user;

  DateTime get createdAt;

  DateTime get updatedAt;

  Comment._();

  factory Comment([void Function(CommentBuilder) updates]) = _$Comment;
}
