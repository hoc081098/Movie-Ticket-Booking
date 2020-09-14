import 'package:datn/domain/model/exception.dart';
import 'package:tuple/tuple.dart';

abstract class UserRepository {
  /// Returns a tuple:
  /// - item1 is true: already logged in -> home page.
  /// - otherwise:
  ///     - item2 is null: logged out -> login page.
  ///     - otherwise: not completed login -> update login profile.
  /// Maybe throw exception.
  Future<Tuple2<bool, NotCompletedLoginException>> checkAuth();

  Future<void> logout();

  Future<void> login(String email, String password);
}
