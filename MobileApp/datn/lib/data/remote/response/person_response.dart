import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'person_response.g.dart';

abstract class PersonResponse
    implements Built<PersonResponse, PersonResponseBuilder> {
  @nullable
  bool get is_active;

  @BuiltValueField(wireName: '_id')
  String get id;

  @nullable
  String get avatar;

  String get full_name;

  DateTime get createdAt;

  DateTime get updatedAt;

  PersonResponse._();

  factory PersonResponse([void Function(PersonResponseBuilder) updates]) =
      _$PersonResponse;

  static Serializer<PersonResponse> get serializer =>
      _$personResponseSerializer;

  factory PersonResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<PersonResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
