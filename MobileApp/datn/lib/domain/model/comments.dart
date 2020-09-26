import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'comment.dart';

part 'comments.g.dart';

abstract class Comments implements Built<Comments, CommentsBuilder> {
  BuiltList<Comment> get comments;

  double get average;

  int get total;

  Comments._();

  factory Comments([void Function(CommentsBuilder) updates]) = _$Comments;
}
