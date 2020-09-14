import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'error_response.g.dart';

abstract class ErrorResponse
    implements Built<ErrorResponse, ErrorResponseBuilder>, Exception {
  int get statusCode;

  String get error;

  @nullable
  String get message;

  ErrorResponse._();

  factory ErrorResponse([void Function(ErrorResponseBuilder) updates]) =
      _$ErrorResponse;

  static Serializer<ErrorResponse> get serializer => _$errorResponseSerializer;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      serializers.deserializeWith<ErrorResponse>(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
