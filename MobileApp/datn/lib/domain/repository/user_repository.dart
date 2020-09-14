abstract class UserRepository {
  Future<bool> checkAuth();

  Future<void> logout();

  Future<void> login(String email, String password);
}
