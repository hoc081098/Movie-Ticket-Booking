// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ComboItem extends ComboItem {
  @override
  final Product product;
  @override
  final int count;

  factory _$ComboItem([void Function(ComboItemBuilder)? updates]) =>
      (new ComboItemBuilder()..update(updates)).build();

  _$ComboItem._({required this.product, required this.count}) : super._() {
    BuiltValueNullFieldError.checkNotNull(product, 'ComboItem', 'product');
    BuiltValueNullFieldError.checkNotNull(count, 'ComboItem', 'count');
  }

  @override
  ComboItem rebuild(void Function(ComboItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComboItemBuilder toBuilder() => new ComboItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComboItem &&
        product == other.product &&
        count == other.count;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, product.hashCode), count.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ComboItem')
          ..add('product', product)
          ..add('count', count))
        .toString();
  }
}

class ComboItemBuilder implements Builder<ComboItem, ComboItemBuilder> {
  _$ComboItem? _$v;

  ProductBuilder? _product;
  ProductBuilder get product => _$this._product ??= new ProductBuilder();
  set product(ProductBuilder? product) => _$this._product = product;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  ComboItemBuilder();

  ComboItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _product = $v.product.toBuilder();
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComboItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ComboItem;
  }

  @override
  void update(void Function(ComboItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ComboItem build() {
    _$ComboItem _$result;
    try {
      _$result = _$v ??
          new _$ComboItem._(
              product: product.build(),
              count: BuiltValueNullFieldError.checkNotNull(
                  count, 'ComboItem', 'count'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'product';
        product.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ComboItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ComboState extends ComboState {
  @override
  final Object? error;
  @override
  final bool isLoading;
  @override
  final BuiltList<ComboItem> items;
  @override
  final int totalPrice;

  factory _$ComboState([void Function(ComboStateBuilder)? updates]) =>
      (new ComboStateBuilder()..update(updates)).build();

  _$ComboState._(
      {this.error,
      required this.isLoading,
      required this.items,
      required this.totalPrice})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(isLoading, 'ComboState', 'isLoading');
    BuiltValueNullFieldError.checkNotNull(items, 'ComboState', 'items');
    BuiltValueNullFieldError.checkNotNull(
        totalPrice, 'ComboState', 'totalPrice');
  }

  @override
  ComboState rebuild(void Function(ComboStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComboStateBuilder toBuilder() => new ComboStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComboState &&
        error == other.error &&
        isLoading == other.isLoading &&
        items == other.items &&
        totalPrice == other.totalPrice;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, error.hashCode), isLoading.hashCode), items.hashCode),
        totalPrice.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ComboState')
          ..add('error', error)
          ..add('isLoading', isLoading)
          ..add('items', items)
          ..add('totalPrice', totalPrice))
        .toString();
  }
}

class ComboStateBuilder implements Builder<ComboState, ComboStateBuilder> {
  _$ComboState? _$v;

  Object? _error;
  Object? get error => _$this._error;
  set error(Object? error) => _$this._error = error;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  ListBuilder<ComboItem>? _items;
  ListBuilder<ComboItem> get items =>
      _$this._items ??= new ListBuilder<ComboItem>();
  set items(ListBuilder<ComboItem>? items) => _$this._items = items;

  int? _totalPrice;
  int? get totalPrice => _$this._totalPrice;
  set totalPrice(int? totalPrice) => _$this._totalPrice = totalPrice;

  ComboStateBuilder();

  ComboStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _isLoading = $v.isLoading;
      _items = $v.items.toBuilder();
      _totalPrice = $v.totalPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComboState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ComboState;
  }

  @override
  void update(void Function(ComboStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ComboState build() {
    _$ComboState _$result;
    try {
      _$result = _$v ??
          new _$ComboState._(
              error: error,
              isLoading: BuiltValueNullFieldError.checkNotNull(
                  isLoading, 'ComboState', 'isLoading'),
              items: items.build(),
              totalPrice: BuiltValueNullFieldError.checkNotNull(
                  totalPrice, 'ComboState', 'totalPrice'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ComboState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
