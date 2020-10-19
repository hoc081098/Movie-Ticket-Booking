import 'dart:convert';

import 'package:file/src/interface/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> setupNotification(BuildContext context) async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await FlutterLocalNotificationsPlugin().initialize(
    initializationSettings,
    onSelectNotification: (payload) => onSelectNotification(context, payload),
  );
}

Future<void> onSelectNotification(
  BuildContext context,
  String payload,
) async {
  print(
      '<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  print('tap $payload');
  print(
      '<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
}

class NotificationId {
  NotificationId._();

  var _id = 0;

  int get id => _id++;

  static final shared = NotificationId._();
}

Future<void> onMessage(Map<String, dynamic> message) async {
  try {
    print('>>>>>>>>>>> onMessage: $message');

    final notification = message['notification'] as Map;
    final data = message['data'] as Map;
    if (notification == null && data == null) {
      return;
    }

    File imageFile;
    try {
      imageFile =
          await DefaultCacheManager().getSingleFile(data['image'] ?? '');
    } catch (_) {}

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.hoc.datn',
      'com.hoc.datn.channel',
      'Enjoy movie notification channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
      styleInformation: imageFile != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imageFile.path),
              hideExpandedLargeIcon: true,
            )
          : null,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().show(
      NotificationId.shared.id,
      notification['title'] ?? data['title'] ?? '',
      notification['body'] ?? data['body'] ?? '',
      platformChannelSpecifics,
      payload: jsonEncode(data),
    );
  } catch (e, s) {
    print('>>>>>>>>>>> onMessage: $message error: $e $s');
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
