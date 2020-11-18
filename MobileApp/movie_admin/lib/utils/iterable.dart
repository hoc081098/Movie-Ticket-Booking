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

extension FirstOrNullIterableExtension<T> on Iterable<T> {
  T get firstOrNull => isEmpty ? null : first;
}

extension MapIndexedIterableExt<T> on Iterable<T> {
  /// Maps each element and its index to a new value.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    var index = 0;
    for (var element in this) {
      yield convert(index++, element);
    }
  }
}

extension SortedIterableExt<T> on Iterable<T> {
  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the natural ordering of the
  /// property [keyOf] of the element.
  List<T> sortedBy<K extends Comparable<K>>(K Function(T element) keyOf) {
    final elements = [...this];
    elements.sort((l, r) => compareComparable(keyOf(l), keyOf(r)));
    return elements;
  }
}

/// A reusable typed comparable comparator.
int compareComparable<T extends Comparable<T>>(T a, T b) => a.compareTo(b);

extension IterableEntriesToMap<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map.fromEntries(this);
}
