import 'package:datn/domain/model/exception.dart';
import 'package:tuple/tuple.dart';

abstract class UserRepository {
  Future<Tuple2<bool, NotCompletedLoginException>> checkAuth();

  Future<void> logout();

  Future<void> login(String email, String password);
}
