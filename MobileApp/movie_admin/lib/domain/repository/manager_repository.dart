import '../model/user.dart';

abstract class ManagerRepository {
  Future<List<User>> loadUser(int page);

  Future<bool> deleteUser(User user);
}
