import 'user_local.dart';

abstract class UserLocalSource {
  Stream<UserLocal> get user$;

  Stream<String> get token$;

  Future<void> saveToken(String token);

  Future<void> saveUser(UserLocal user);
}
