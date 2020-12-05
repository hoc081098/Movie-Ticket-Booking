import 'package:flutter/material.dart';

extension ShowSnackbarGlobalKeyScaffoldStateExtension
    on GlobalKey<ScaffoldState> {
  void showSnackBar(
    String message, [
    Duration duration = const Duration(seconds: 2),
  ]) =>
      currentContext?.showSnackBar(message, duration);
}

extension ShowSnackBarBuildContextExtension on BuildContext {
  void showSnackBar(
    String message, [
    Duration duration = const Duration(seconds: 2),
  ]) {
    ScaffoldMessengerState messengerState;
    try {
      messengerState = ScaffoldMessenger.maybeOf(this);
      if (messengerState == null) {
        return;
      }
      messengerState.hideCurrentSnackBar();
      messengerState.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
        ),
      );
    } catch (_) {}
  }
}
