import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'promotion_response.g.dart';

abstract class PromotionResponse
    implements Built<PromotionResponse, PromotionResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  String get code;

  double get discount;

  DateTime get end_time;

  bool? get is_active;

  String get name;

  DateTime get start_time;

  String get creator;

  String get show_time;

  DateTime get createdAt;

  DateTime get updatedAt;

  PromotionResponse._();

  factory PromotionResponse([void Function(PromotionResponseBuilder) updates]) =
      _$PromotionResponse;

  static Serializer<PromotionResponse> get serializer =>
      _$promotionResponseSerializer;

  factory PromotionResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<PromotionResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
