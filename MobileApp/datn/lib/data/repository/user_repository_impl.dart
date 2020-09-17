import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:datn/data/local/user_local.dart';
import 'package:datn/data/local/user_local_source.dart';
import 'package:datn/data/remote/auth_client.dart';
import 'package:datn/data/remote/base_url.dart';
import 'package:datn/data/remote/response/error_response.dart';
import 'package:datn/data/remote/response/user_response.dart';
import 'package:datn/domain/model/exception.dart';
import 'package:datn/domain/model/location.dart';
import 'package:datn/domain/model/user.dart';
import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/utils/optional.dart';
import 'package:datn/utils/type_defs.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final UserLocalSource _userLocalSource;

  final AuthClient _authClient;
  final NormalClient _normalClient;

  final Function1<UserResponse, UserLocal> _userResponseToUserLocal;

  Future<AuthState> _checkAuthFuture;
  final ValueConnectableStream<Optional<User>> _user$;

  UserRepositoryImpl(
    this._auth,
    this._userLocalSource,
    this._authClient,
    this._normalClient,
    this._userResponseToUserLocal,
    this._storage,
    Function1<UserLocal, User> userLocalToUserDomain,
  ) : _user$ = valueConnectableStream(
          _auth,
          _userLocalSource,
          userLocalToUserDomain,
        ) {
    _checkAuthFuture = _checkAuthInternal();
  }

  static ValueConnectableStream<Optional<User>> valueConnectableStream(
    FirebaseAuth _auth,
    UserLocalSource _userLocalSource,
    Function1<UserLocal, User> userLocalToUserDomain,
  ) =>
      Rx.combineLatest3<dynamic, UserLocal, String, Optional<User>>(
              _auth.userChanges(),
              _userLocalSource.user$,
              _userLocalSource.token$,
              (user, UserLocal local, String token) =>
                  user == null || local == null || token == null
                      ? Optional.none()
                      : Optional.some(userLocalToUserDomain(local)))
          .publishValueSeeded(null)
            ..connect();

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

    await _userLocalSource.saveToken(await _auth.currentUser.getIdToken(true));

    try {
      final json = await _authClient.getBody(buildUrl('users/me'));
      final userLocal = _userResponseToUserLocal(UserResponse.fromJson(json));
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

  Future _saveUserResponseToLocal(UserResponse userResponse) async {
    final userLocal = _userResponseToUserLocal(userResponse);
    await _userLocalSource.saveUser(userLocal);

    if (!userResponse.isCompleted) {
      throw const NotCompletedLoginException();
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

    final currentUser = _auth.currentUser;

    await currentUser.reload();
    if (!currentUser.emailVerified) {
      unawaited(currentUser.sendEmailVerification());
      throw const NotVerifiedEmail();
    }

    final token = await currentUser.getIdToken();
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

    await _saveUserResponseToLocal(userResponse);
  }

  @override
  Future<void> loginUpdateProfile(
      {String fullName,
      String phoneNumber,
      String address,
      Gender gender,
      Location location,
      DateTime birthday,
      File avatarFile}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const NotLoggedInException();
    }

    final updateBody = <String, dynamic>{
      'full_name': fullName,
      'phone_number': phoneNumber,
      'address': address,
    };

    if (avatarFile != null) {
      final task = _storage
          .ref()
          .child('avatar_images')
          .child(currentUser.uid)
          .putFile(avatarFile);

      await task.onComplete;

      if (task.isSuccessful) {
        updateBody['avatar'] =
            (await task.lastSnapshot.ref.getDownloadURL()).toString();
      }
    }

    if (birthday != null) {
      updateBody['birthday'] = birthday.toIso8601String();
    }
    if (location != null) {
      updateBody['location'] = [
        location.longitude,
        location.latitude,
      ];
    }
    updateBody['gender'] = gender.toString().split('.')[1];

    final userResponse = UserResponse.fromJson(
      await _authClient.putBody(buildUrl('users/me'),
          body: jsonEncode(updateBody),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          }),
    );

    await _saveUserResponseToLocal(userResponse);
  }

  /// Tries to create a new user account with the given email address and
  /// password.
  ///
  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **email-already-in-use**:
  ///  - Thrown if there already exists an account with the given email address.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **operation-not-allowed**:
  ///  - Thrown if email/password accounts are not enabled. Enable
  ///    email/password accounts in the Firebase Console, under the Auth tab.
  /// - **weak-password**:
  ///  - Thrown if the password is not strong enough.
  @override
  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _auth.currentUser.sendEmailVerification();
    await _auth.signOut();
  }

  @override
  ValueStream<Optional<User>> get user$ => _user$;

  @override
  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);
}
