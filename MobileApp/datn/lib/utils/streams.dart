import 'dart:async';

import 'package:flutter/widgets.dart' hide Notification;
import 'package:listenable_stream/listenable_stream.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

extension DebugMapStreamsExtension on Map<String, Stream<dynamic>> {
  List<StreamSubscription<dynamic>> debug() {
    return entries
        .map((entry) =>
            entry.value.cast<dynamic>().debug(identifier: entry.key).collect())
        .toList(growable: false);
  }
}

extension ScrollPositionStreamExt on ScrollController {
  Stream<void> nearBottomEdge$() => toStream()
      .throttleTime(
        const Duration(milliseconds: 100),
        trailing: true,
        leading: true,
      )
      .where((sc) =>
          sc.hasClients && sc.offset + 56 * 2 >= sc.position.maxScrollExtent)
      .mapTo<void>(null);
}
