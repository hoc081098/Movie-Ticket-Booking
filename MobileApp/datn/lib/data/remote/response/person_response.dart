import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'person_response.g.dart';

abstract class PersonResponse
    implements Built<PersonResponse, PersonResponseBuilder> {
  bool? get is_active;

  @BuiltValueField(wireName: '_id')
  String get id;

  String? get avatar;

  String get full_name;

  DateTime get createdAt;

  DateTime get updatedAt;

  PersonResponse._();

  factory PersonResponse([void Function(PersonResponseBuilder) updates]) =
      _$PersonResponse;

  static Serializer<PersonResponse> get serializer =>
      _$personResponseSerializer;

  factory PersonResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<PersonResponse>(serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
