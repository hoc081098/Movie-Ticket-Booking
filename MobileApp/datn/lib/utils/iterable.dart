import 'dart:math';

import 'package:built_collection/built_collection.dart';

import 'type_defs.dart';

extension GroupByIterableExtension<T> on Iterable<T> {
  Map<K, List<V>> groupBy<K, V>(
    Function1<T, K> keySelector,
    Function1<T, V> valueTransform,
  ) {
    final map = <K, List<V>>{};
    forEach((e) {
      final key = keySelector(e);
      final value = valueTransform(e);
      final list = map[key];

      if (list == null) {
        map[key] = [value];
      } else {
        list.add(value);
      }
    });
    return map;
  }
}

extension SafeReplaceListBuilderExtension<T> on ListBuilder<T> {
  void safeReplace(Iterable<T> iterable) => replace(iterable);
}

extension RandomIterableExtension<T> on Iterable<T> {
  T random() => elementAt(Random().nextInt(length));
}

extension IsNullOrEmptyIterableExtension<T> on Iterable<T>? {
  bool get isNullOrEmpty {
    final self = this;
    return self == null || self.isEmpty;
  }
}

extension DistinctIterableExtension<T> on Iterable<T> {
  Iterable<T> distinct() {
    final set = <T>{};
    return where(set.add);
  }
}
