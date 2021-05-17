import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:disposebag/disposebag.dart';
import 'package:distinct_value_connectable_stream/distinct_value_connectable_stream.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:tuple/tuple.dart';

import '../../../domain/repository/product_repository.dart';
import '../../../utils/utils.dart';
import 'combo_state.dart';

class MaxComboCount {
  const MaxComboCount();
}

class ComboBloc extends BaseBloc {
  final _messageS = PublishSubject<MaxComboCount>(sync: true);
  final _fetchS = StreamController<void>(sync: true);
  final _incrementS = StreamController<ComboItem>(sync: true);
  final _decrementS = StreamController<ComboItem>(sync: true);
  final _bag = DisposeBag();

  late DistinctValueConnectableStream<ComboState> _state$;

  ValueStream<ComboState> get state$ => _state$;

  Stream<MaxComboCount> get message$ => _messageS;

  ComboBloc(ProductRepository productRepository) {
    final loadingState = ComboState.from(
      error: null,
      isLoading: true,
      items: BuiltList.of(<ComboItem>[]),
      totalPrice: 0,
    );

    final fetchState$ = _fetchS.stream
        .debug(identifier: 'FETCH', log: streamDebugPrint)
        .exhaustMap(
          (_) => productRepository
              .getProducts()
              .map(
                (products) => products
                    .map((p) => ComboItem.from(product: p, count: 0))
                    .toBuiltList(),
              )
              .map(
                (items) => ComboState.from(
                  error: null,
                  isLoading: false,
                  items: items,
                  totalPrice: 0,
                ),
              )
              .startWith(loadingState)
              .onErrorReturnWith(
                (error, s) => ComboState.from(
                  error: error,
                  isLoading: false,
                  items: BuiltList.of(<ComboItem>[]),
                  totalPrice: 0,
                ),
              ),
        )
        .debug(identifier: 'FETCH STATE', log: streamDebugPrint);

    final stateS = BehaviorSubject.seeded(loadingState);
    final incDecState$ = Rx.merge([
      _incrementS.stream.map((item) => Tuple2(item, 1)),
      _decrementS.stream.map((item) => Tuple2(item, -1)),
    ]).withLatestFrom(stateS, _incDecCount);

    _state$ = Rx.merge([fetchState$, incDecState$])
        .publishValueDistinct(loadingState);
    _state$.listen(stateS.add).disposedBy(_bag);
    _state$.listen(print).disposedBy(_bag);
    _state$.connect().disposedBy(_bag);

    _bag.addAll([_messageS, _fetchS, _incrementS, _decrementS, stateS]);
  }

  ComboState _incDecCount(Tuple2<ComboItem, int> tuple, ComboState state) {
    if (state.items.isEmpty) {
      return state;
    }

    final newTotalCount = state.items.fold<int>(
      0,
      (acc, i) => i.product.id == tuple.item1.product.id
          ? acc + i.count + tuple.item2
          : acc + i.count,
    );
    print('totalCount $newTotalCount');
    if (newTotalCount > 20) {
      _messageS.add(const MaxComboCount());
      return state;
    }

    final itemMapper = (ComboItem item) {
      if (item.product.id != tuple.item1.product.id) {
        return item;
      }

      final count = item.count + tuple.item2;
      if (count < 0) {
        return item;
      }

      return item.rebuild((b) => b.count = count);
    };

    return state.rebuild((b) {
      final newItems = state.items.map(itemMapper).toList(growable: false);

      b.items.safeReplace(newItems);
      b.totalPrice = newItems.fold<int>(
        0,
        (acc, e) => acc + e.count * e.product.price,
      );
    });
  }

  void fetch() => _fetchS.add(null);

  void increment(ComboItem item) => _incrementS.add(item);

  void decrement(ComboItem item) => _decrementS.add(item);

  @override
  void dispose() {
    print('$runtimeType disposed');
    _bag.dispose();
  }
}
