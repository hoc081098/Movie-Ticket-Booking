import 'dart:io';

import 'package:datn/domain/model/location.dart';
import 'package:datn/domain/model/user.dart';
import 'package:datn/utils/optional.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/streams.dart';

enum AuthState {
  loggedIn,
  notLoggedIn,
  notCompletedLogin,
}

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
}
