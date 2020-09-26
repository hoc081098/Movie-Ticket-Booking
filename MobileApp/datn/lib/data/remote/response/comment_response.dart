import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';
import 'user_response.dart';

part 'comment_response.g.dart';

abstract class CommentResponse
    implements Built<CommentResponse, CommentResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  @nullable
  bool get is_active;

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

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<CommentResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
