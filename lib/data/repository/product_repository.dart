import 'package:fake_store/data/model/product.dart';
import 'package:fake_store/data/productApi.dart';

class ProductRepository {
  final ProductApi _productApi = ProductApi();

  Future<List<Product>> getProducts() async {
    return _productApi.fetchProducts();
  }
}
