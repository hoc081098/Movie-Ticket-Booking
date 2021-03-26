import 'package:meta/meta.dart';

class Credential {
  final String email;
  final String password;

  const Credential({required this.email, required this.password});
}

@immutable
abstract class RegisterMessage {}

class RegisterSuccessMessage implements RegisterMessage {
  final String email;

  const RegisterSuccessMessage(this.email);
}

class RegisterErrorMessage implements RegisterMessage {
  final Object error;
  final String message;

  const RegisterErrorMessage(this.message, this.error);

  @override
  String toString() => 'LoginErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements RegisterMessage {
  const InvalidInformationMessage();
}
