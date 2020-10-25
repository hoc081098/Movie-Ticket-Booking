import '../model/user.dart';

abstract class ManagerRepository {
  Future<List<User>> loadUser(int page);

  Future<User> deleteUser(User user);

  Future<User> blockUser(User user);

  Future<User> unblockUser(User user);
}
