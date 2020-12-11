import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/exception.dart';
import '../../domain/model/location.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../utils/optional.dart';
import '../../utils/type_defs.dart';
import '../local/user_local.dart';
import '../local/user_local_source.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/error_response.dart';
import '../remote/response/user_response.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final UserLocalSource _userLocalSource;

  final AuthClient _authClient;

  final Function1<UserResponse, UserLocal> _userResponseToUserLocal;
  final GoogleSignIn _googleSignIn;

  final ValueConnectableStream<Optional<User>> _user$;

  UserRepositoryImpl(
    this._auth,
    this._userLocalSource,
    this._authClient,
    this._userResponseToUserLocal,
    this._storage,
    Function1<UserLocal, User> userLocalToUserDomain,
    this._googleSignIn,
  ) : _user$ = valueConnectableStream(
          _auth,
          _userLocalSource,
          userLocalToUserDomain,
        );

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
        : local.is_completed
            ? local.role == Role.USER.string()
                ? AuthState.notForRole
                : AuthState.loggedIn
            : AuthState.notCompletedLogin;
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
      print(json);
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

    if (!userResponse.is_completed) {
      throw const NotCompletedLoginException();
    }
  }

  Future _checkCompletedLoginAfterFirebaseLogin() async {
    final currentUser = _auth.currentUser;

    final token = await currentUser.getIdToken();
    await _userLocalSource.saveToken(token);

    UserResponse userResponse;
    try {
      final json = await _authClient.getBody(buildUrl('users/me'));
      userResponse = UserResponse.fromJson(json);
      if (userResponse.role == Role.USER.string()) {
        throw const WrongRoleException();
      }
    } on ErrorResponse catch (e) {
      if (e.statusCode == HttpStatus.notFound) {
        throw const NotCompletedLoginException();
      }
      rethrow;
    }

    await _saveUserResponseToLocal(userResponse);
  }

  @override
  Future<AuthState> checkAuth() => _checkAuthInternal();

  @override
  Future<void> logout() async {
    // google
    unawaited(() async {
      try {
        await _googleSignIn.disconnect();
        print('_googleSignIn.disconnect');
      } catch (e) {
        print('_googleSignIn.disconnect error: $e');
      }
    }());
    await _googleSignIn.signOut();

    // firebase
    await _auth.signOut();

    // local
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

    await _checkCompletedLoginAfterFirebaseLogin();
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

      await task;

      updateBody['avatar'] = await task.snapshot.ref.getDownloadURL();
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
      await _authClient.putBody(
        buildUrl('users/me'),
        body: updateBody,
      ),
    );

    await _saveUserResponseToLocal(userResponse);
  }

  @override
  ValueStream<Optional<User>> get user$ => _user$;

  @override
  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> googleSignIn() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      throw PlatformException(
        code: GoogleSignIn.kSignInCanceledError,
        message: 'Google sign in canceled',
        details: null,
      );
    }

    final authentication = await googleAccount.authentication;
    await _auth.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      ),
    );

    await _checkCompletedLoginAfterFirebaseLogin();
  }
}
