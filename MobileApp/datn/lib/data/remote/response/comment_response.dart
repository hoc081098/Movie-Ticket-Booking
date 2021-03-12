import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'user_response.dart';

part 'comment_response.g.dart';

abstract class CommentResponse
    implements Built<CommentResponse, CommentResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  bool? get is_active;

  String get content;

  int get rate_star;

  String get movie;

  UserResponse get user;

  DateTime get createdAt;

  DateTime get updatedAt;

  CommentResponse._();

  factory CommentResponse([void Function(CommentResponseBuilder) updates]) =
      _$CommentResponse;

  static Serializer<CommentResponse> get serializer =>
      _$commentResponseSerializer;

  factory CommentResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<CommentResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
