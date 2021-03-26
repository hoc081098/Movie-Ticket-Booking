import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'product_response.g.dart';

abstract class ProductResponse
    implements Built<ProductResponse, ProductResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get description;

  String get image;

  bool? get is_active;

  String get name;

  int get price;

  DateTime get createdAt;

  DateTime get updatedAt;

  ProductResponse._();

  factory ProductResponse([void Function(ProductResponseBuilder) updates]) =
      _$ProductResponse;

  static Serializer<ProductResponse> get serializer =>
      _$productResponseSerializer;

  factory ProductResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<ProductResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
