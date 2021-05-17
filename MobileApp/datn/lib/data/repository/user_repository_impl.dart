import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../domain/model/exception.dart';
import '../../domain/model/location.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../utils/utils.dart';
import '../local/search_keyword_source.dart';
import '../local/user_local.dart';
import '../local/user_local_source.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/error_response.dart';
import '../remote/response/user_response.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final FirebaseMessaging _firebaseMessaging;
  final UserLocalSource _userLocalSource;

  final AuthHttpClient _authClient;

  final Function1<UserResponse, UserLocal> _userResponseToUserLocal;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  final SearchKeywordSource _searchKeywordSource;

  final ValueStream<Optional<User>?> _user$;

  UserRepositoryImpl(
    this._auth,
    this._userLocalSource,
    this._authClient,
    this._userResponseToUserLocal,
    this._storage,
    Function1<UserLocal, User> userLocalToUserDomain,
    this._googleSignIn,
    this._facebookAuth,
    this._firebaseMessaging,
    this._searchKeywordSource,
  ) : _user$ = _buildUserStream(
          _auth,
          _userLocalSource,
          userLocalToUserDomain,
        );

  Future<Map<String, String>?> get _fcmTokenHeaders => _firebaseMessaging
      .getToken()
      .then((token) => token != null ? {'fcm_token': token} : null);

  static ValueStream<Optional<User>?> _buildUserStream(
    FirebaseAuth _auth,
    UserLocalSource _userLocalSource,
    Function1<UserLocal, User> userLocalToUserDomain,
  ) =>
      Rx.combineLatest3<Object?, UserLocal?, String?, Optional<User>?>(
              _auth.userChanges(),
              _userLocalSource.user$,
              _userLocalSource.token$,
              (Object? user, UserLocal? local, String? token) =>
                  user == null || local == null || token == null
                      ? Optional.none()
                      : Optional.some(userLocalToUserDomain(local)))
          .publishValueSeeded(null)
            ..connect();

  Future<AuthState> _isUserLocalCompletedLogin([UserLocal? local]) async {
    local ??= await _userLocalSource.user;

    return local == null
        ? AuthState.notLoggedIn
        : local.isCompleted
            ? AuthState.loggedIn
            : AuthState.notCompletedLogin;
  }

  Future<AuthState> _checkAuthInternal() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      await logout();
      print('[Check auth][1] not logged in');
      return AuthState.notLoggedIn;
    }

    await _userLocalSource.saveToken(await currentUser.getIdToken(true));

    try {
      final json = await _authClient.getJson(
        buildUrl('users/me'),
        headers: await _fcmTokenHeaders,
      );
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

  Future _checkCompletedLoginAfterFirebaseLogin([
    bool checkVerifyEmail = false,
  ]) async {
    final currentUser = _auth.currentUser!;

    if (checkVerifyEmail) {
      await currentUser.reload();

      if (!currentUser.emailVerified) {
        unawaited(currentUser.sendEmailVerification());
        await logout();
        throw const NotVerifiedEmail();
      }
    }

    final token = await currentUser.getIdToken();
    await _userLocalSource.saveToken(token);

    UserResponse userResponse;
    try {
      final json = await _authClient.getJson(
        buildUrl('users/me'),
        headers: await _fcmTokenHeaders,
      );
      userResponse = UserResponse.fromJson(json);
      if (userResponse.role != 'USER') {
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

    // facebook
    await _facebookAuth.logOut();

    // firebase
    await _auth.signOut();

    // local
    await _searchKeywordSource.clear();
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

    await _checkCompletedLoginAfterFirebaseLogin(true);
  }

  @override
  Future<void> loginUpdateProfile({
    required String fullName,
    required String phoneNumber,
    required String address,
    required Gender gender,
    Location? location,
    DateTime? birthday,
    File? avatarFile,
  }) async {
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
      updateBody['birthday'] = birthday.toUtc().toIso8601String();
    }
    if (location != null) {
      updateBody['location'] = [
        location.longitude,
        location.latitude,
      ];
    }
    updateBody['gender'] = describeEnum(gender);

    final userResponse = UserResponse.fromJson(
      await _authClient.putJson(
        buildUrl('users/me'),
        body: updateBody,
      ),
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
    await _auth.currentUser!.sendEmailVerification();
    await logout();
  }

  @override
  ValueStream<Optional<User>?> get user$ => _user$;

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

  @override
  Future<void> facebookSignIn() async {
    final loginResult = await _facebookAuth.login();

    switch (loginResult.status) {
      case LoginStatus.cancelled:
        throw PlatformException(
          code: 'cancelled',
          message: 'Facebook sign in canceled',
          details: null,
        );
      case LoginStatus.failed:
        throw PlatformException(
          code: 'failed',
          message: 'Login failed',
          details: null,
        );
      case LoginStatus.operationInProgress:
        throw PlatformException(
          code: 'operationInProgress',
          message: 'You have a previous login operation in progress',
          details: null,
        );
      case LoginStatus.success:
        final token = loginResult.accessToken?.token;

        if (token == null) {
          throw PlatformException(
            code: 'error',
            message: 'Login failed. Token is null',
            details: null,
          );
        }

        await _auth
            .signInWithCredential(FacebookAuthProvider.credential(token));
        await _checkCompletedLoginAfterFirebaseLogin();
    }
  }
}
