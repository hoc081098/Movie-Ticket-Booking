import 'dart:async';
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

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _auth;
  final UserLocalSource _userLocalSource;

  final AuthClient _authClient;
  final NormalClient _normalClient;

  final Function1<UserResponse, UserLocal> userResponseToUserLocal;

  Future<AuthState> _checkAuthFuture;

  UserRepositoryImpl(
    this._auth,
    this._userLocalSource,
    this._authClient,
    this._normalClient,
    this.userResponseToUserLocal,
  ) {
    _checkAuthFuture = _checkAuthInternal();
  }

  Future<AuthState> _isUserLocalCompletedLogin([UserLocal local]) async {
    local ??= await _userLocalSource.user$.first;

    return local == null
        ? AuthState.notLoggedIn
        : local.isCompleted ? AuthState.loggedIn : AuthState.notCompletedLogin;
  }

  Future<AuthState> _checkAuthInternal() async {
    if (_auth.currentUser == null) {
      await logout();
      print('[Check auth][1] not logged in');
      return AuthState.notLoggedIn;
    }

    if (await _userLocalSource.token$.first == null) {
      await _userLocalSource.saveToken(await _auth.currentUser.getIdToken());
    }

    try {
      final json = await _authClient.getBody(buildUrl('users/me'));
      final userLocal = userResponseToUserLocal(UserResponse.fromJson(json));
      await _userLocalSource.saveUser(userLocal);

      return _isUserLocalCompletedLogin(userLocal);
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        print('[Check auth][2] 404 not completed login error: $e');
        return AuthState.notCompletedLogin;
      }

      if (e.statusCode == HttpStatus.unauthorized ||
          e.statusCode == HttpStatus.forbidden) {
        await logout();
        print('[Check auth][2] 401 or 403');
        return AuthState.notLoggedIn;
      }

      print('[Check auth][2] error response $e');
      return _isUserLocalCompletedLogin();
    } catch (e) {
      print('[Check auth][3] other error: $e');
      return _isUserLocalCompletedLogin();
    }
  }

  @override
  Future<AuthState> checkAuth() {
    if (_checkAuthFuture != null) {
      final future = _checkAuthFuture;
      _checkAuthFuture = null;
      return future;
    }

    return _checkAuthInternal();
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
