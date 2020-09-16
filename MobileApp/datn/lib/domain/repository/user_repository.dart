import 'dart:io';

import 'package:datn/domain/model/location.dart';
import 'package:datn/domain/model/user.dart';
import 'package:meta/meta.dart';

enum AuthState {
  loggedIn,
  notLoggedIn,
  notCompletedLogin,
}

abstract class UserRepository {
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
