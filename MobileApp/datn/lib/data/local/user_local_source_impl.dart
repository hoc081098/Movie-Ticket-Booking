import 'dart:convert';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import 'user_local.dart';
import 'user_local_source.dart';

class UserLocalSourceImpl implements UserLocalSource {
  static const _tokenKey = 'com.hoc.datn.token';
  static const _userKey = 'com.hoc.datn.user';

  final RxSharedPreferences _preferences;

  UserLocalSourceImpl(this._preferences);

  @override
  Future<void> saveToken(String token) =>
      _preferences.setString(_tokenKey, token);

  @override
  Future<void> saveUser(UserLocal user) async => user == null
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

  @override
  Future<String> get token =>
      _preferences.getString(_tokenKey).catchError((e) => null);

  @override
  Future<UserLocal> get user => _preferences
      .getString(_userKey)
      .then(_toUserLocal)
      .catchError((e) => null);
}
