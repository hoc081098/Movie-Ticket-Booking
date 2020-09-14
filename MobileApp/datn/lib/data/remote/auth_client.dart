import 'dart:async';
import 'dart:io';

import 'package:datn/data/local/user_local_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class AuthClient extends BaseClient {
  final Client _client;
  final UserLocalSource _userLocalSource;
  final FirebaseAuth _auth;

  AuthClient(this._client, this._userLocalSource, this._auth);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final token = await _userLocalSource.token$.first;

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    print('--> ${request}');
    return _client.send(request).then(_handleResponse);
  }

  Future<StreamedResponse> _handleResponse(StreamedResponse response) async {
    print('<-- ${response.statusCode} ${response.request}');

    if (response.statusCode == HttpStatus.unauthorized ||
        response.statusCode == HttpStatus.forbidden) {
      await _auth.signOut();
      await _userLocalSource.saveToken(null);
      await _userLocalSource.saveUser(null);
      print('Response code is 401 or 403. Removed token. Logout');
    }

    return response;
  }
}
