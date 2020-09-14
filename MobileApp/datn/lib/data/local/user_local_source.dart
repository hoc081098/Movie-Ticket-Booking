
import 'package:datn/data/local/user_local.dart';

abstract class UserLocalSource {
  Stream<UserLocal> get user$;

  Stream<String> get token$;

  Future<bool> saveToken(String token);

  Future<bool> saveUser(UserLocal user);
}