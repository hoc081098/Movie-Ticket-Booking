import 'dart:io';

import 'package:datn/data/remote/reponse/error_response.dart';
import 'package:datn/domain/model/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

String getErrorMessage(dynamic error) {
  if (error is String) {
    return error;
  }
  if (error is NotCompletedLoginException) {
    return 'Required updating your profile';
  }
  if (error is ErrorResponse) {
    return error.message;
  }
  if (error is SocketException) {
    return 'No internet connection';
  }
  if (error is FirebaseAuthException) {
    return error.message;
  }
  if (error is PlatformException) {
    return error.message;
  }
  return 'Error: $error';
}
