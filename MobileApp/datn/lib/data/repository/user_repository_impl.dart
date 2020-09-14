import 'dart:io';

import 'package:datn/data/local/user_local.dart';
import 'package:datn/data/local/user_local_source.dart';
import 'package:datn/data/remote/auth_client.dart';
import 'package:datn/data/remote/base_url.dart';
import 'package:datn/data/remote/reponse/error_response.dart';
import 'package:datn/data/remote/reponse/user_response.dart';
import 'package:datn/domain/model/exception.dart';
import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/utils/type_defs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _auth;
  final UserLocalSource _userLocalSource;

  final AuthClient _authClient;
  final NormalClient _normalClient;

  final Function1<UserResponse, UserLocal> userResponseToUserLocal;

  UserRepositoryImpl(
    this._auth,
    this._userLocalSource,
    this._authClient,
    this._normalClient,
    this.userResponseToUserLocal,
  );

  @override
  Future<Tuple2<bool, NotCompletedLoginException>> checkAuth() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      await logout();
      print('[Check auth] not logged in');
      return Tuple2(false, null);
    }

    final token = await _auth.currentUser.getIdToken();
    await _userLocalSource.saveToken(token);

    try {
      final json = await _authClient.getBody(buildUrl('users/me'));
      final userResponse = UserResponse.fromJson(json);

      final userLocal = userResponseToUserLocal(userResponse);
      await _userLocalSource.saveUser(userLocal);

      if (!userResponse.isCompleted) {
        return Tuple2(false, const NotCompletedLoginException());
      }
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        print('[Check auth] 404 not completed login error: $e');
        return Tuple2(false, const NotCompletedLoginException());
      }
      if (e.statusCode == HttpStatus.unauthorized ||
          e.statusCode == HttpStatus.forbidden) {
        await logout();
        print('[Check auth] 401 or 403');
        return Tuple2(false, null);
      }
    } catch (e) {
      print('[Check auth] other error: $e');
    }

    return Tuple2(true, null);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _userLocalSource.saveToken(null);
    await _userLocalSource.saveUser(null);
  }

  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **user-disabled**:
  ///  - Thrown if the user corresponding to the given email has been disabled.
  /// - **user-not-found**:
  ///  - Thrown if there is no user corresponding to the given email.
  /// - **wrong-password**:
  ///  - Thrown if the password is invalid for the given email, or the account
  ///    corresponding to the email does not have a password set.
  @override
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final token = await _auth.currentUser.getIdToken();
    await _userLocalSource.saveToken(token);

    UserResponse userResponse;
    try {
      final json = await _normalClient.getBody(
        buildUrl('users/me'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
      );
      userResponse = UserResponse.fromJson(json);
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedLoginException();
      }
      rethrow;
    }

    final userLocal = userResponseToUserLocal(userResponse);
    await _userLocalSource.saveUser(userLocal);

    if (!userResponse.isCompleted) {
      throw const NotCompletedLoginException();
    }
  }
}

Function1<UserResponse, UserLocal> userResponseToUserLocal = (response) {
  return UserLocal((b) => b
    ..uid = response.uid
    ..email = response.email
    ..phoneNumber = response.phoneNumber
    ..fullName = response.fullName
    ..gender = response.gender
    ..avatar = response.avatar
    ..address = response.address
    ..birthday = response.birthday
    ..location = (LocationLocalBuilder()
      ..latitude = response.location.latitude
      ..longitude = response.location.longitude)
    ..isCompleted = response.isCompleted
    ..isActive = response.isActive);
};
