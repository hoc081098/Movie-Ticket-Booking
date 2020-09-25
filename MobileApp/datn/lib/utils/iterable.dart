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
