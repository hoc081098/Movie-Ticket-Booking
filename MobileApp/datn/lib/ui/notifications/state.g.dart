// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$State extends State {
  @override
  final int page;
  @override
  final BuiltList<Notification> items;
  @override
  final bool isLoading;
  @override
  final Object error;
  @override
  final bool loadedAll;

  factory _$State([void Function(StateBuilder) updates]) =>
      (new StateBuilder()..update(updates)).build();

  _$State._({this.page, this.items, this.isLoading, this.error, this.loadedAll})
      : super._() {
    if (page == null) {
      throw new BuiltValueNullFieldError('State', 'page');
    }
    if (items == null) {
      throw new BuiltValueNullFieldError('State', 'items');
    }
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('State', 'isLoading');
    }
    if (loadedAll == null) {
      throw new BuiltValueNullFieldError('State', 'loadedAll');
    }
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
        items == other.items &&
        isLoading == other.isLoading &&
        error == other.error &&
        loadedAll == other.loadedAll;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, page.hashCode), items.hashCode), isLoading.hashCode),
            error.hashCode),
        loadedAll.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('State')
          ..add('page', page)
          ..add('items', items)
          ..add('isLoading', isLoading)
          ..add('error', error)
          ..add('loadedAll', loadedAll))
        .toString();
  }
}

class StateBuilder implements Builder<State, StateBuilder> {
  _$State _$v;

  int _page;
  int get page => _$this._page;
  set page(int page) => _$this._page = page;

  ListBuilder<Notification> _items;
  ListBuilder<Notification> get items =>
      _$this._items ??= new ListBuilder<Notification>();
  set items(ListBuilder<Notification> items) => _$this._items = items;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  Object _error;
  Object get error => _$this._error;
  set error(Object error) => _$this._error = error;

  bool _loadedAll;
  bool get loadedAll => _$this._loadedAll;
  set loadedAll(bool loadedAll) => _$this._loadedAll = loadedAll;

  StateBuilder();

  StateBuilder get _$this {
    if (_$v != null) {
      _page = _$v.page;
      _items = _$v.items?.toBuilder();
      _isLoading = _$v.isLoading;
      _error = _$v.error;
      _loadedAll = _$v.loadedAll;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(State other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$State;
  }

  @override
  void update(void Function(StateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$State build() {
    _$State _$result;
    try {
      _$result = _$v ??
          new _$State._(
              page: page,
              items: items.build(),
              isLoading: isLoading,
              error: error,
              loadedAll: loadedAll);
    } catch (_) {
      String _$failedField;
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
