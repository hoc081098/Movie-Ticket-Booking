import 'package:meta/meta.dart';

@immutable
abstract class Message {}

class SuccessMessage implements Message {
  final String email;

  const SuccessMessage(this.email);
}

class ErrorMessage implements Message {
  final Object error;
  final String message;

  const ErrorMessage(this.message, this.error);
}

class InvalidInformationMessage implements Message {
  const InvalidInformationMessage();
}
