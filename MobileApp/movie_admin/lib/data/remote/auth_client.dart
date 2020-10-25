import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utils/type_defs.dart';
import 'response/error_response.dart';

abstract class AppClient extends BaseClient {
  /// Sends an HTTP GET request with the given headers to the given URL, which can be a Uri or a String.
  /// Returns the resulting Json object.
  /// Throws [ErrorResponse]
  Future<dynamic> getBody(Uri url, {Map<String, String> headers}) =>
      this.get(url, headers: headers).then(_parseResult);

  Future<dynamic> postBody(
    Uri url, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) =>
      this
          .post(
            url,
            headers: {
              ...?headers,
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
            body: jsonEncode(body),
          )
          .then(_parseResult);

  Future<dynamic> putBody(
    Uri url, {
    Map<String, String> headers,
    Map<String, dynamic> body,
  }) =>
      this
          .put(
            url,
            headers: {
              ...?headers,
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
            body: body != null ? jsonEncode(body) : null,
          )
          .then(_parseResult);

  Future<dynamic> deleteBody(dynamic url, {Map<String, String> headers}) =>
      this.delete(url, headers: headers).then(_parseResult);

  static dynamic _parseResult(Response response) {
    final statusCode = response.statusCode;
    print(statusCode);
    final json = jsonDecode(response.body);

    if (HttpStatus.ok <= statusCode &&
        statusCode <= HttpStatus.multipleChoices) {
      return json;
    }

    final request = response.request;

    ErrorResponse errorResponse;
    try {
      errorResponse = SingleMessageErrorResponse.fromJson(json);
    } catch (e1, s1) {
      print(
          '<-- ${request} Parse SingleMessageErrorResponse error: ${e1} ${s1}');

      try {
        errorResponse = MultipleMessagesErrorResponse.fromJson(json);
      } catch (e2, s2) {
        print(
            '<-- ${request} Parse MultipleMessagesErrorResponse error: ${e2} ${s2}');
        throw ParseErrorResponseException([e1, e2]);
      }
    }

    assert(errorResponse != null);
    print('<-- ${request} errorResponse=$errorResponse');
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
  final Duration _timeout;

  final Function0<Future<void>> _onSignOut;
  final Function0<Future<String>> _getToken;

  AuthClient(
    this._client,
    this._timeout,
    this._onSignOut,
    this._getToken,
  );

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final token = await _getToken();

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
      await _onSignOut();
      print('Response code is 401 or 403. Removed token. Logout');
    }

    return response;
  }
}
