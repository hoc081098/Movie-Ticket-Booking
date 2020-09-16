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
