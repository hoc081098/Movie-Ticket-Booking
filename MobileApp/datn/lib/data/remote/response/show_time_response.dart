import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'show_time_response.g.dart';

abstract class ShowTimeResponse
    implements Built<ShowTimeResponse, ShowTimeResponseBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  bool? get is_active;

  String get movie;

  String get theatre;

  String get room;

  DateTime get end_time;

  DateTime get start_time;

  DateTime get createdAt;

  DateTime get updatedAt;

  ShowTimeResponse._();

  factory ShowTimeResponse([void Function(ShowTimeResponseBuilder) updates]) =
      _$ShowTimeResponse;

  static Serializer<ShowTimeResponse> get serializer =>
      _$showTimeResponseSerializer;

  factory ShowTimeResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<ShowTimeResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
