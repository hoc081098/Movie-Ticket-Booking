import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

part 'product.g.dart';

abstract class Product implements Built<Product, ProductBuilder> {
  String get id;

  String get description;

  String get image;

  bool get is_active;

  String get name;

  int get price;

  DateTime get createdAt;

  DateTime get updatedAt;

  Product._();

  factory Product([void Function(ProductBuilder) updates]) = _$Product;

  factory Product.from({
    @required String id,
    @required String description,
    @required String image,
    @required bool is_active,
    @required String name,
    @required int price,
    @required DateTime createdAt,
    @required DateTime updatedAt,
  }) = _$Product._;
}
