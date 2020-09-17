import 'package:meta/meta.dart';

class Credential {
  final String email;
  final String password;

  const Credential({this.email, this.password});
}

@immutable
abstract class RegisterMessage {}

class RegisterSuccessMessage implements RegisterMessage {
  const RegisterSuccessMessage();
}

class RegisterErrorMessage implements RegisterMessage {
  final Object error;
  final String message;

  const RegisterErrorMessage(this.message, [this.error]);

  @override
  String toString() => 'LoginErrorMessage{message=$message, error=$error}';
}

class InvalidInformationMessage implements RegisterMessage {
  const InvalidInformationMessage();
}
