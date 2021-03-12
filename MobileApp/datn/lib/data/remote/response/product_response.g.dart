// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ProductResponse> _$productResponseSerializer =
    new _$ProductResponseSerializer();

class _$ProductResponseSerializer
    implements StructuredSerializer<ProductResponse> {
  @override
  final Iterable<Type> types = const [ProductResponse, _$ProductResponse];
  @override
  final String wireName = 'ProductResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, ProductResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'image',
      serializers.serialize(object.image,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'price',
      serializers.serialize(object.price, specifiedType: const FullType(int)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(DateTime)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(DateTime)),
    ];
    Object? value;
    value = object.is_active;
    if (value != null) {
      result
        ..add('is_active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  ProductResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProductResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '_id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'is_active':
          result.is_active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$ProductResponse extends ProductResponse {
  @override
  final String id;
  @override
  final String description;
  @override
  final String image;
  @override
  final bool? is_active;
  @override
  final String name;
  @override
  final int price;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$ProductResponse([void Function(ProductResponseBuilder)? updates]) =>
      (new ProductResponseBuilder()..update(updates)).build();

  _$ProductResponse._(
      {required this.id,
      required this.description,
      required this.image,
      this.is_active,
      required this.name,
      required this.price,
      required this.createdAt,
      required this.updatedAt})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'ProductResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(
        description, 'ProductResponse', 'description');
    BuiltValueNullFieldError.checkNotNull(image, 'ProductResponse', 'image');
    BuiltValueNullFieldError.checkNotNull(name, 'ProductResponse', 'name');
    BuiltValueNullFieldError.checkNotNull(price, 'ProductResponse', 'price');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, 'ProductResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        updatedAt, 'ProductResponse', 'updatedAt');
  }

  @override
  ProductResponse rebuild(void Function(ProductResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductResponseBuilder toBuilder() =>
      new ProductResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductResponse &&
        id == other.id &&
        description == other.description &&
        image == other.image &&
        is_active == other.is_active &&
        name == other.name &&
        price == other.price &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), description.hashCode),
                            image.hashCode),
                        is_active.hashCode),
                    name.hashCode),
                price.hashCode),
            createdAt.hashCode),
        updatedAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ProductResponse')
          ..add('id', id)
          ..add('description', description)
          ..add('image', image)
          ..add('is_active', is_active)
          ..add('name', name)
          ..add('price', price)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ProductResponseBuilder
    implements Builder<ProductResponse, ProductResponseBuilder> {
  _$ProductResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  bool? _is_active;
  bool? get is_active => _$this._is_active;
  set is_active(bool? is_active) => _$this._is_active = is_active;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ProductResponseBuilder();

  ProductResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _description = $v.description;
      _image = $v.image;
      _is_active = $v.is_active;
      _name = $v.name;
      _price = $v.price;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ProductResponse;
  }

  @override
  void update(void Function(ProductResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProductResponse build() {
    final _$result = _$v ??
        new _$ProductResponse._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'ProductResponse', 'id'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, 'ProductResponse', 'description'),
            image: BuiltValueNullFieldError.checkNotNull(
                image, 'ProductResponse', 'image'),
            is_active: is_active,
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'ProductResponse', 'name'),
            price: BuiltValueNullFieldError.checkNotNull(
                price, 'ProductResponse', 'price'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, 'ProductResponse', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, 'ProductResponse', 'updatedAt'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
