import '../entities/product.dart';
import '../entities/product_page.dart';

abstract class ProductRepository {
  Future<ProductPage> getProducts(ProductQuery query);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(int id, Product product);
  Future<void> deleteProduct(int id);
}
