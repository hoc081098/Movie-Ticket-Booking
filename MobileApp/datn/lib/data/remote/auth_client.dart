import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../utils/utils.dart';
import 'response/error_response.dart';

AppHttpClientLogger? get _logger => AppClientLoggerDefaults.logger;

class AppClientLoggerDefaults {
  static AppHttpClientLogger? logger;

  AppClientLoggerDefaults._();
}

abstract class AppHttpClientLogger {
  /// Logging HTTP request.
  void logRequest(String request);

  /// Logging HTTP request body.
  void logRequestBody(String body);

  /// Logging HTTP response.
  void logResponse(String response);

  /// Logging HTTP response body.
  void logResponseBody(String body);
}

final _indent = ' ' * 4;

void _logRequest(BaseRequest request) {
  _logger?.logRequest('--> $request');

  if (request.method == 'POST' || request.method == 'PUT') {
    if (request is Request) {
      _logger
          ?.logRequestBody('${_indent}bodyBytes: ${request.bodyBytes.length}');
      try {
        _logger?.logRequestBody('${_indent}body: ' + request.body);
      } catch (_) {}

      try {
        _logger?.logRequestBody('${_indent}bodyFields: ${request.bodyFields}');
      } catch (_) {}
    }

    if (request is MultipartRequest) {
      _logger?.logRequestBody('${_indent}fields: ${request.fields}');
      _logger?.logRequestBody('${_indent}files: ${request.files}');
    }
  }
}

StreamedResponse _logResponse(StreamedResponse response) {
  _logger?.logResponse('<-- ${response.statusCode} ${response.request}');
  return response;
}

Object? _toEncodable(Object? nonEncodable) =>
    nonEncodable is DateTime ? nonEncodable.toIso8601String() : nonEncodable;

abstract class AppHttpClient extends BaseClient {
  /// Sends an HTTP GET request with the given headers to the given URL, which can be a Uri or a String.
  /// Returns the resulting Json object.
  /// Throws [ErrorResponse]
  Future<dynamic> getJson(Uri url, {Map<String, String>? headers}) =>
      this.get(url, headers: headers).then(_parseResult);

  Future<dynamic> postMultipart(
    Uri url,
    List<int> bytes, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    String? filename,
  }) {
    final request = MultipartRequest('POST', url)
      ..fields.addAll(fields ?? const <String, String>{})
      ..files.add(
        MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename ?? 'file_${DateTime.now().toIso8601String()}',
        ),
      )
      ..headers.addAll(<String, String>{
        ...?headers,
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
      });

    return send(request)
        .then((res) => Response.fromStream(res))
        .then(_parseResult);
  }

  Future<dynamic> postJson(
    Uri url, {
    Map<String, String>? headers,
    Map<String, Object?>? body,
  }) =>
      this
          .post(
            url,
            headers: {
              ...?headers,
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
            body: jsonEncode(body, toEncodable: _toEncodable),
          )
          .then(_parseResult);

  Future<dynamic> putJson(
    Uri url, {
    Map<String, String>? headers,
    Map<String, Object?>? body,
  }) =>
      this
          .put(
            url,
            headers: {
              ...?headers,
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
            body: body != null
                ? jsonEncode(body, toEncodable: _toEncodable)
                : null,
          )
          .then(_parseResult);

  Future<dynamic> deleteJson(Uri url, {Map<String, String>? headers}) =>
      this.delete(url, headers: headers).then(_parseResult);

  static dynamic _parseResult(Response response) {
    try {
      _logger?.logResponseBody('${_indent}body: ' + response.body);
    } catch (_) {}

    final statusCode = response.statusCode;

    if (HttpStatus.ok <= statusCode &&
        statusCode <= HttpStatus.multipleChoices) {
      return jsonDecode(response.body);
    }

    Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body);
    } catch (e, s) {
      throw ParseErrorResponseException([e], [s]);
    }

    ErrorResponse errorResponse;
    try {
      errorResponse = SingleMessageErrorResponse.fromJson(json);
    } catch (e1, s1) {
      try {
        errorResponse = MultipleMessagesErrorResponse.fromJson(json);
      } catch (e2, s2) {
        throw ParseErrorResponseException([e1, e2], [s1, s2]);
      }
    }
    _logger?.logResponse('${_indent}errorResponse=$errorResponse');
    throw errorResponse;
  }
}

class NormalHttpClient extends AppHttpClient {
  final Client _client;
  final Duration _timeout;

  NormalHttpClient(this._client, this._timeout);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    _logRequest(request);
    return _client.send(request).timeout(_timeout).then(_logResponse);
  }
}

class AuthHttpClient extends AppHttpClient {
  final Client _client;
  final Duration _timeout;

  final Function0<Future<void>> _onSignOut;
  final Function0<Future<String?>> _getToken;

  AuthHttpClient(
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
    _logRequest(request);
    return _client.send(request).timeout(_timeout).then(_handleResponse);
  }

  Future<StreamedResponse> _handleResponse(StreamedResponse response) async {
    _logResponse(response);

    if (response.statusCode == HttpStatus.unauthorized ||
        response.statusCode == HttpStatus.forbidden) {
      await _onSignOut();
      _logger
          ?.logResponse('Response code is 401 or 403. Removed token. Logout');
    }

    return response;
  }
}

class DevAppClientLogger implements AppHttpClientLogger {
  static const _tag = '🚀 [DEV-HTTP] ';

  const DevAppClientLogger();

  @override
  void logRequest(String request) => print(_tag + request);

  @override
  void logRequestBody(String body) => print(_tag + body);

  @override
  void logResponse(String response) => print(_tag + response);

  @override
  void logResponseBody(String body) => print(_tag + body);
}

class ProdAppClientLogger implements AppHttpClientLogger {
  static const _tag = '🚀 [PROD-HTTP] ';

  const ProdAppClientLogger();

  @override
  void logRequest(String request) => print(_tag + request);

  @override
  void logRequestBody(String body) {}

  @override
  void logResponse(String response) => print(_tag + response);

  @override
  void logResponseBody(String body) {}
}
