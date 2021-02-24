import 'dart:async';

import 'package:rxdart_ext/rxdart_ext.dart';

extension DebugMapStreamsExtension on Map<String, Stream<dynamic>> {
  List<StreamSubscription<dynamic>> debug() {
    return entries
        .map((entry) =>
            entry.value.cast<dynamic>().debug(identifier: entry.key).collect())
        .toList(growable: false);
  }
}
