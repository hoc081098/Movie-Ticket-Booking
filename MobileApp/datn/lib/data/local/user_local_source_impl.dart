import 'dart:convert';

import 'package:datn/data/local/user_local.dart';
import 'package:datn/data/local/user_local_source.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class UserLocalSourceImpl implements UserLocalSource {
  static const _tokenKey = 'com.hoc.datn.token';
  static const _userKey = 'com.hoc.datn.user';

  final RxSharedPreferences _preferences;

  UserLocalSourceImpl(this._preferences);

  @override
  Future<bool> saveToken(String token) =>
      _preferences.setString(_tokenKey, token);

  @override
  Future<bool> saveUser(UserLocal user) async => user == null
      ? await _preferences.remove(_userKey)
      : await _preferences.setString(_userKey, jsonEncode(user));

  @override
  Stream<String> get token$ =>
      _preferences.getStringStream(_tokenKey).onErrorReturn(null);

  @override
  Stream<UserLocal> get user$ => _preferences
      .getStringStream(_userKey)
      .map(_toUserLocal)
      .onErrorReturn(null);

  static UserLocal _toUserLocal(String jsonString) {
    return jsonString == null
        ? null
        : UserLocal.fromJson(jsonDecode(jsonString));
  }
}
