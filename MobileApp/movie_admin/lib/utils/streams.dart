import 'dart:async';

import 'package:rxdart/rxdart.dart';

extension DebugMapStreamsExtension on Map<String, Stream<dynamic>> {
  List<StreamSubscription> debug() => entries
      .map((entry) =>
          entry.value.listen((data) => print('[DEBUG] [${entry.key}] = $data')))
      .toList();
}

extension NotificationExt<T> on Notification<T> {
  String get description {
    switch (kind) {
      case Kind.OnData:
        return 'data(${value})';
      case Kind.OnDone:
        return 'done';
      case Kind.OnError:
        return 'error(${error})';
    }
    return '';
  }
}

extension DebugExt<T> on Stream<T> {
  Stream<T> debug([String identifier]) {
    identifier ??= 'Debug';

    void logEvent(String content) =>
        print('${DateTime.now()}: $identifier -> $content');

    return transform(
      DoStreamTransformer(
        onEach: (notification) => logEvent('Event ${notification.description}'),
        onListen: () => logEvent('Listened'),
        onCancel: () => logEvent('Cancelled'),
        onPause: ([_]) => logEvent('Paused'),
        onResume: () => logEvent('Resumed'),
      ),
    );
  }
}

extension MapNotNullStreamExt<T> on Stream<T> {
  Stream<R> mapNotNull<R>(R Function(T) mapper) {
    return transform(StreamTransformer<T, R>.fromHandlers(
      handleData: (data, sink) {
        final mapped = mapper(data);
        if (mapped != null) {
          sink.add(mapped);
        }
      },
      handleError: (e, st, sink) => sink.addError(e, st),
      handleDone: (sink) => sink.close(),
    ));
  }
}
