import 'dart:convert';

import 'package:file/src/interface/file.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart' hide Notification;

import 'data/mappers.dart' show notificationResponseToNotification;
import 'data/remote/auth_client.dart';
import 'data/remote/base_url.dart';
import 'data/remote/response/notification_response.dart';
import 'domain/model/notification.dart';

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

class FcmNotificationManager {
  final AuthClient _authClient;

  var _id = 0;
  final _cacheManager = DefaultCacheManager();
  final _notificationS = PublishSubject<Map<dynamic, dynamic>>();

  Stream<Notification> _notification$;

  FcmNotificationManager(this._authClient) {
    _notification$ = _notificationS
        .map((data) => data['_id'])
        .whereType<String>()
        .asyncExpand(_getNotificationById)
        .share();
  }

  Stream<Notification> _getNotificationById(String id) => Rx.fromCallable(
        () => _authClient.getBody(buildUrl('/notifications/${id}')).then(
              (json) => notificationResponseToNotification(
                  NotificationResponse.fromJson(json)),
            ),
      );

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
        imageFile = await _cacheManager.getSingleFile(data['image'] ?? '');
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
        _id++,
        notification['title'] ?? data['title'] ?? '',
        notification['body'] ?? data['body'] ?? '',
        platformChannelSpecifics,
        payload: jsonEncode(data),
      );

      _notificationS.add(data);
    } catch (e, s) {
      print('>>>>>>>>>>> onMessage: $message error: $e $s');
    }
  }

  Stream<Notification> get notification$ => _notification$;
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print(notification);
  }

  // Or do other work.
}
