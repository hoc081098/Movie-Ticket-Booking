import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'comment_response.dart';

part 'comments_response.g.dart';

abstract class CommentsResponse
    implements Built<CommentsResponse, CommentsResponseBuilder> {
  BuiltList<CommentResponse> get comments;

  double get average;

  int get total;

  CommentsResponse._();

  factory CommentsResponse([void Function(CommentsResponseBuilder) updates]) =
      _$CommentsResponse;

  static Serializer<CommentsResponse> get serializer =>
      _$commentsResponseSerializer;

  factory CommentsResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<CommentsResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
