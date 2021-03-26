import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'category_response.g.dart';

abstract class CategoryResponse
    implements Built<CategoryResponse, CategoryResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get name;

  DateTime get createdAt;

  DateTime get updatedAt;

  bool? get is_active;

  CategoryResponse._();

  factory CategoryResponse([void Function(CategoryResponseBuilder) updates]) =
      _$CategoryResponse;

  static Serializer<CategoryResponse> get serializer =>
      _$categoryResponseSerializer;

  factory CategoryResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<CategoryResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
