import 'package:built_collection/built_collection.dart';

import '../model/product.dart';

abstract class ProductRepository {
  Stream<BuiltList<Product>> getProducts();
}
