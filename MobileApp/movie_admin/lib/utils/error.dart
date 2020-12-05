import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../data/remote/response/error_response.dart';
import '../domain/model/exception.dart';

String getErrorMessage(dynamic error) {
  if (error is String) {
    return error;
  }

  // domain errors
  if (error is NotCompletedLoginException) {
    return 'Required updating your profile';
  }
  if (error is NotLoggedInException) {
    return 'Not logged in';
  }
  if (error is WrongRoleException) {
    return 'Only ADMIN or STAFF role is allowed';
  }

  // server error
  if (error is SingleMessageErrorResponse) {
    return error.message;
  }
  if (error is MultipleMessagesErrorResponse) {
    return error.messages.join('\n');
  }

  // network error
  if (error is SocketException) {
    return 'No internet connection';
  }
  if (error is TimeoutException) {
    return 'Slow internet connection';
  }
  if (error is HttpException) {
    return 'Network error';
  }
  if (error is ClientException) {
    return 'Network error';
  }

  // firebase & platform errors
  if (error is FirebaseAuthException) {
    return error.message;
  }
  if (error is PlatformException) {
    return error.message;
  }

  return 'Error: $error';
}
