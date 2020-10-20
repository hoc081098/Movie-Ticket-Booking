import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';

import '../../domain/repository/notification_repository.dart';
import '../../utils/streams.dart';
import '../app_scaffold.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AppScaffold.tapStream(context)
    .where((event) => event == 2)
    .take(1)
    .listen((event) {
      Provider.of<NotificationRepository>(context)
          .getNotification(page: 1, perPage: 32)
          .debug('>> NOTIFICATION')
          .listen(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text('Hi'),
      ),
    );
  }
}
