import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:datn/data/local/user_local_source.dart';
import 'package:datn/data/remote/reponse/error_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

abstract class AppClient extends BaseClient {
  /// Sends an HTTP GET request with the given headers to the given URL, which can be a Uri or a String.
  /// Returns the resulting Json object.
  /// Throws [ErrorResponse]
  Future<dynamic> getBody(dynamic url, {Map<String, String> headers}) =>
      this.get(url, headers: headers).then(_parseResult);

  Future<dynamic> postBody(
    dynamic url, {
    Map<String, String> headers,
    dynamic body,
    Encoding encoding,
  }) =>
      this
          .post(url, headers: headers, body: body, encoding: encoding)
          .then(_parseResult);

  static dynamic _parseResult(Response response) {
    final statusCode = response.statusCode;
    final json = jsonDecode(response.body);

    if (HttpStatus.ok <= statusCode &&
        statusCode <= HttpStatus.multipleChoices) {
      return json;
    }

    dynamic errorResponse;
    try {
      errorResponse = ErrorResponse.fromJson(json);
    } catch (e) {
      try {
        errorResponse = null;
      } catch (_) {
        throw e;
      }
    }
    throw errorResponse;
  }
}

class NormalClient extends AppClient {
  final Client _client;
  final Duration _timeout;

  NormalClient(this._client, this._timeout);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    print('--> ${request}');
    return _client.send(request).timeout(_timeout).then(_logResponse);
  }

  static StreamedResponse _logResponse(response) {
    print('<-- ${response.statusCode} ${response.request}');
    return response;
  }
}

class AuthClient extends AppClient {
  final Client _client;
  final UserLocalSource _userLocalSource;
  final FirebaseAuth _auth;
  final Duration _timeout;

  AuthClient(this._client, this._userLocalSource, this._auth, this._timeout);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final token = await _userLocalSource.token$.first;

    if (token != null) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    print('--> ${request}');
    return _client.send(request).timeout(_timeout).then(_handleResponse);
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
