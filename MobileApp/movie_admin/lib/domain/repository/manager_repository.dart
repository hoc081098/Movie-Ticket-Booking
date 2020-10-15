import 'package:movie_admin/domain/model/user.dart';

abstract class ManagerRepository {
  Future<List<User>> getAllUser();
}
