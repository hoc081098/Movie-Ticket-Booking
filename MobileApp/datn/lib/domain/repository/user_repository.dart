import 'package:datn/domain/model/exception.dart';
import 'package:tuple/tuple.dart';

enum AuthState {
  loggedIn,
  notLoggedIn,
  notCompletedLogin,
}

abstract class UserRepository {
  Future<AuthState> checkAuth();

  Future<void> logout();

  Future<void> login(String email, String password);
}
