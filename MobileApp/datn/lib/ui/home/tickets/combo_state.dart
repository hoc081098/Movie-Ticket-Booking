import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import '../../../domain/model/product.dart';

part 'combo_state.g.dart';

abstract class ComboItem implements Built<ComboItem, ComboItemBuilder> {
  Product get product;

  int get count;

  ComboItem._();

  factory ComboItem([void Function(ComboItemBuilder) updates]) = _$ComboItem;

  factory ComboItem.from({required Product product, required int count}) =
      _$ComboItem._;
}

abstract class ComboState implements Built<ComboState, ComboStateBuilder> {
  Object? get error;

  bool get isLoading;

  BuiltList<ComboItem> get items;

  int get totalPrice;

  ComboState._();

  factory ComboState([void Function(ComboStateBuilder) updates]) = _$ComboState;

  factory ComboState.from({
    required Object? error,
    required bool isLoading,
    required BuiltList<ComboItem> items,
    required int totalPrice,
  }) = _$ComboState._;
}
