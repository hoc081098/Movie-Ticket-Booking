abstract class ErrorResponse {
  int get statusCode;

  String get error;
}

class SingleMessageErrorResponse implements ErrorResponse {
  @override
  final String error;

  @override
  final int statusCode;

  final String message;

  SingleMessageErrorResponse(this.error, this.statusCode, this.message);

  factory SingleMessageErrorResponse.fromJson(Map<String, dynamic> map) {
    return SingleMessageErrorResponse(
        map['error'], map['statusCode'], map['message']);
  }

  @override
  String toString() {
    return 'SingleMessageErrorResponse{error: $error, statusCode: $statusCode, message: $message}';
  }
}

class MultipleMessagesErrorResponse implements ErrorResponse {
  @override
  final String error;

  @override
  final int statusCode;

  final List<String> messages;

  MultipleMessagesErrorResponse(this.error, this.statusCode, this.messages);

  factory MultipleMessagesErrorResponse.fromJson(Map<String, dynamic> map) {
    return MultipleMessagesErrorResponse(
      map['error'],
      map['statusCode'],
      (map['message'] as List).cast<String>(),
    );
  }

  @override
  String toString() {
    return 'MultipleMessagesErrorResponse{error: $error, statusCode: $statusCode, messages: $messages}';
  }
}

class ParseErrorResponseException implements Exception {
  final List<Object> errors;

  ParseErrorResponseException(this.errors);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParseErrorResponseException &&
          runtimeType == other.runtimeType &&
          errors == other.errors;

  @override
  int get hashCode => errors.hashCode;

  @override
  String toString() => 'ParseErrorResponseException{errors: $errors}';
}
