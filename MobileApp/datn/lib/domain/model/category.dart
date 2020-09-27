import 'package:built_value/built_value.dart';

part 'category.g.dart';

abstract class Category implements Built<Category, CategoryBuilder> {
  String get id;

  String get name;

  DateTime get createdAt;

  DateTime get updatedAt;

  bool get is_active;

  Category._();

  factory Category([void Function(CategoryBuilder) updates]) = _$Category;
}
