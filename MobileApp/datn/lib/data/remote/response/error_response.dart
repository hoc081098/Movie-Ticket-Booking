import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../../serializers.dart';

part 'error_response.g.dart';

abstract class ErrorResponse {
  int get statusCode;

  String? get error;
}

class ParseErrorResponseException implements Exception {
  final List<Object> errors;
  final List<StackTrace> stackTraces;

  ParseErrorResponseException(this.errors, this.stackTraces);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParseErrorResponseException &&
          runtimeType == other.runtimeType &&
          errors == other.errors &&
          stackTraces == other.stackTraces;

  @override
  int get hashCode => errors.hashCode ^ stackTraces.hashCode;

  @override
  String toString() =>
      'ParseErrorResponseException{errors: $errors, stackTraces: $stackTraces}';
}

abstract class SingleMessageErrorResponse
    implements
        Built<SingleMessageErrorResponse, SingleMessageErrorResponseBuilder>,
        ErrorResponse {
  @override
  int get statusCode;

  @override
  String? get error;

  String? get message;

  SingleMessageErrorResponse._();

  factory SingleMessageErrorResponse(
          [void Function(SingleMessageErrorResponseBuilder) updates]) =
      _$SingleMessageErrorResponse;

  static Serializer<SingleMessageErrorResponse> get serializer =>
      _$singleMessageErrorResponseSerializer;

  factory SingleMessageErrorResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<SingleMessageErrorResponse>(
          serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}

abstract class MultipleMessagesErrorResponse
    implements
        Built<MultipleMessagesErrorResponse,
            MultipleMessagesErrorResponseBuilder>,
        ErrorResponse {
  @override
  int get statusCode;

  @override
  String? get error;

  @BuiltValueField(wireName: 'message')
  BuiltList<String>? get messages;

  MultipleMessagesErrorResponse._();

  factory MultipleMessagesErrorResponse(
          [void Function(MultipleMessagesErrorResponseBuilder) updates]) =
      _$MultipleMessagesErrorResponse;

  static Serializer<MultipleMessagesErrorResponse> get serializer =>
      _$multipleMessagesErrorResponseSerializer;

  factory MultipleMessagesErrorResponse.fromJson(Map<String, Object?> json) =>
      serializers.deserializeWith<MultipleMessagesErrorResponse>(
          serializer, json)!;

  Map<String, Object?> toJson() =>
      serializers.serializeWith(serializer, this) as Map<String, Object?>;
}
