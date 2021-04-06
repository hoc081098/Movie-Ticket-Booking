import 'package:built_collection/built_collection.dart';

import '../../domain/model/product.dart';
import '../../domain/repository/product_repository.dart';
import '../remote/auth_client.dart';
import '../remote/base_url.dart';
import '../remote/response/product_response.dart';
import '../serializers.dart';

class ProductRepositoryImpl implements ProductRepository {
  final AuthHttpClient _authClient;
  final Product Function(ProductResponse) _productResponseToProduct;

  ProductRepositoryImpl(this._authClient, this._productResponseToProduct);

  @override
  Stream<BuiltList<Product>> getProducts() async* {
    final json = await _authClient.getJson(buildUrl('/products'));

    final productResponses = serializers.deserialize(
      json,
      specifiedType: builtListProductResponse,
    ) as BuiltList<ProductResponse>;

    yield productResponses.map(_productResponseToProduct).toBuiltList();
  }
}
