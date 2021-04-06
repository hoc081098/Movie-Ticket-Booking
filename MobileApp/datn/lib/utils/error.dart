import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:utils/utils.dart';

import '../data/remote/response/error_response.dart';
import '../domain/model/exception.dart';
import '../generated/l10n.dart';

@deprecated
String getErrorMessageDeprecated(Object error) =>
    S.current.getErrorMessage(error);

extension ErrorMessageS on S {
  String get _unknownError => 'Unknown error'; // TODO: l10n

  String getErrorMessage(Object error) {
    ArgumentError.checkNotNull(error);

    if (error is String) {
      return error;
    }

    // domain errors
    if (error is NotCompletedLoginException) {
      return requiredUpdatingYourProfile;
    }
    if (error is NotLoggedInException) {
      return notLoggedIn;
    }
    if (error is NotVerifiedEmail) {
      return yourAccountEmailHasNotBeenVerifyPleaseVerifyTo;
    }
    if (error is WrongRoleException) {
      return onlyUserRoleIsAllowed;
    }

    // server error
    if (error is SingleMessageErrorResponse) {
      return error.message ?? _unknownError;
    }
    if (error is MultipleMessagesErrorResponse) {
      return error.messages.isNullOrEmpty
          ? _unknownError
          : error.messages!.join('\n');
    }

    // network error
    if (error is SocketException) {
      return noInternetConnection;
    }
    if (error is TimeoutException) {
      return slowInternetConnection;
    }
    if (error is HttpException) {
      return networkError;
    }
    if (error is ClientException) {
      return networkError;
    }

    // firebase & platform errors
    if (error is FirebaseAuthException) {
      return error.message ?? _unknownError;
    }
    if (error is PlatformException) {
      return error.message ?? _unknownError;
    }

    return error.toString();
  }
}

extension ErrorMessageBuildContext on BuildContext {
  String getErrorMessage(Object error) => S.of(this).getErrorMessage(error);
}

extension ErrorMessageState on State {
  String getErrorMessage(Object error) => context.getErrorMessage(error);
}
