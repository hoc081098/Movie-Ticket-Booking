// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Category extends Category {
  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final bool is_active;

  factory _$Category([void Function(CategoryBuilder)? updates]) =>
      (new CategoryBuilder()..update(updates)).build();

  _$Category._(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt,
      required this.is_active})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Category', 'id');
    BuiltValueNullFieldError.checkNotNull(name, 'Category', 'name');
    BuiltValueNullFieldError.checkNotNull(createdAt, 'Category', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(updatedAt, 'Category', 'updatedAt');
    BuiltValueNullFieldError.checkNotNull(is_active, 'Category', 'is_active');
  }

  @override
  Category rebuild(void Function(CategoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoryBuilder toBuilder() => new CategoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Category &&
        id == other.id &&
        name == other.name &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        is_active == other.is_active;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), name.hashCode), createdAt.hashCode),
            updatedAt.hashCode),
        is_active.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Category')
          ..add('id', id)
          ..add('name', name)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('is_active', is_active))
        .toString();
  }
}

class CategoryBuilder implements Builder<Category, CategoryBuilder> {
  _$Category? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  CategoryBuilder();

  CategoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _is_active = $v.is_active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Category other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Category;
  }

  @override
  void update(void Function(CategoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Category build() {
    final _$result = _$v ??
        new _$Category._(
            id: BuiltValueNullFieldError.checkNotNull(id, 'Category', 'id'),
            name:
                BuiltValueNullFieldError.checkNotNull(name, 'Category', 'name'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, 'Category', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, 'Category', 'updatedAt'),
            is_active: BuiltValueNullFieldError.checkNotNull(
                is_active, 'Category', 'is_active'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
