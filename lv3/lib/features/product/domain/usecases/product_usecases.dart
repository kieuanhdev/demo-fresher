import '../entities/product.dart';
import '../entities/product_page.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repo;
  GetProductsUseCase(this._repo);
  Future<ProductPage> call(ProductQuery query) => _repo.getProducts(query);
}

class CreateProductUseCase {
  final ProductRepository _repo;
  CreateProductUseCase(this._repo);
  Future<Product> call(Product p) => _repo.createProduct(p);
}

class UpdateProductUseCase {
  final ProductRepository _repo;
  UpdateProductUseCase(this._repo);
  Future<Product> call(int id, Product p) => _repo.updateProduct(id, p);
}

class DeleteProductUseCase {
  final ProductRepository _repo;
  DeleteProductUseCase(this._repo);
  Future<void> call(int id) => _repo.deleteProduct(id);
}
