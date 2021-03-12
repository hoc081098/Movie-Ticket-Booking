// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$State extends State {
  @override
  final int page;
  @override
  final double average;
  @override
  final int total;
  @override
  final BuiltList<Comment> items;
  @override
  final bool isLoading;
  @override
  final Object? error;
  @override
  final bool loadedAll;

  factory _$State([void Function(StateBuilder)? updates]) =>
      (new StateBuilder()..update(updates)).build();

  _$State._(
      {required this.page,
      required this.average,
      required this.total,
      required this.items,
      required this.isLoading,
      this.error,
      required this.loadedAll})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(page, 'State', 'page');
    BuiltValueNullFieldError.checkNotNull(average, 'State', 'average');
    BuiltValueNullFieldError.checkNotNull(total, 'State', 'total');
    BuiltValueNullFieldError.checkNotNull(items, 'State', 'items');
    BuiltValueNullFieldError.checkNotNull(isLoading, 'State', 'isLoading');
    BuiltValueNullFieldError.checkNotNull(loadedAll, 'State', 'loadedAll');
  }

  @override
  State rebuild(void Function(StateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StateBuilder toBuilder() => new StateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is State &&
        page == other.page &&
        average == other.average &&
        total == other.total &&
        items == other.items &&
        isLoading == other.isLoading &&
        error == other.error &&
        loadedAll == other.loadedAll;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, page.hashCode), average.hashCode),
                        total.hashCode),
                    items.hashCode),
                isLoading.hashCode),
            error.hashCode),
        loadedAll.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('State')
          ..add('page', page)
          ..add('average', average)
          ..add('total', total)
          ..add('items', items)
          ..add('isLoading', isLoading)
          ..add('error', error)
          ..add('loadedAll', loadedAll))
        .toString();
  }
}

class StateBuilder implements Builder<State, StateBuilder> {
  _$State? _$v;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  double? _average;
  double? get average => _$this._average;
  set average(double? average) => _$this._average = average;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ListBuilder<Comment>? _items;
  ListBuilder<Comment> get items =>
      _$this._items ??= new ListBuilder<Comment>();
  set items(ListBuilder<Comment>? items) => _$this._items = items;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  Object? _error;
  Object? get error => _$this._error;
  set error(Object? error) => _$this._error = error;

  bool? _loadedAll;
  bool? get loadedAll => _$this._loadedAll;
  set loadedAll(bool? loadedAll) => _$this._loadedAll = loadedAll;

  StateBuilder();

  StateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _page = $v.page;
      _average = $v.average;
      _total = $v.total;
      _items = $v.items.toBuilder();
      _isLoading = $v.isLoading;
      _error = $v.error;
      _loadedAll = $v.loadedAll;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(State other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$State;
  }

  @override
  void update(void Function(StateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$State build() {
    _$State _$result;
    try {
      _$result = _$v ??
          new _$State._(
              page:
                  BuiltValueNullFieldError.checkNotNull(page, 'State', 'page'),
              average: BuiltValueNullFieldError.checkNotNull(
                  average, 'State', 'average'),
              total: BuiltValueNullFieldError.checkNotNull(
                  total, 'State', 'total'),
              items: items.build(),
              isLoading: BuiltValueNullFieldError.checkNotNull(
                  isLoading, 'State', 'isLoading'),
              error: error,
              loadedAll: BuiltValueNullFieldError.checkNotNull(
                  loadedAll, 'State', 'loadedAll'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'State', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
