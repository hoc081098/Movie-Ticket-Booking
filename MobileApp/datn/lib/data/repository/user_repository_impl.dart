import 'package:datn/data/local/user_local_source.dart';
import 'package:datn/data/remote/base_url.dart';
import 'package:datn/domain/repository/user_repository.dart';
import 'package:datn/utils/delay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _auth;
  final UserLocalSource _userLocalSource;
  final http.Client _authClient;

  UserRepositoryImpl(this._auth, this._userLocalSource, this._authClient);

  @override
  Future<bool> checkAuth() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null ||
        await _userLocalSource.token$.first == null ||
        await _userLocalSource.user$.first == null) {
      await logout();
      return false;
    }

    final response = await _authClient.get(buildUrl('users/me'));
    print(response);

    return true;
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _userLocalSource.saveToken(null);
    await _userLocalSource.saveUser(null);
  }

  @override
  Future<void> login(String email, String password) async {
    await delay(1000);
    throw UnimplementedError();
  }
}
