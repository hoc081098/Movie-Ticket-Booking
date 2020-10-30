import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

import '../../utils/optional.dart';
import '../model/location.dart';
import '../model/user.dart';

enum AuthState { loggedIn, notLoggedIn, notCompletedLogin, notForRole }

abstract class UserRepository {
  /// Returns a [ValueStream]
  /// - [ValueStream.value] is null when no actual value is emitted.
  /// - [ValueStream.value] is [Some] when user logged in.
  /// - [ValueStream.value] is [None] when user not logged in.
  ValueStream<Optional<User>> get user$;

  Future<AuthState> checkAuth();

  Future<void> logout();

  Future<void> login(String email, String password);

  Future<void> loginUpdateProfile({
    @required String fullName,
    @required String phoneNumber,
    @required String address,
    @required Gender gender,
    Location location,
    DateTime birthday,
    File avatarFile,
  });

  Future<void> resetPassword(String email);

  Future<void> googleSignIn();
}
