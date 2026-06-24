import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_page.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  ProductRepositoryImpl(this._remote);

  @override
  Future<ProductPage> getProducts(ProductQuery query) => _guard(() async {
        final raw = await _remote.getProducts(query);
        return ProductPage(
          items: raw.items,
          page: query.page,
          limit: query.limit,
          total: raw.total,
        );
      });

  @override
  Future<Product> createProduct(Product product) =>
      _guard(() => _remote.createProduct(ProductModel.fromEntity(product)));

  @override
  Future<Product> updateProduct(int id, Product product) => _guard(
      () => _remote.updateProduct(id, ProductModel.fromEntity(product)));

  @override
  Future<void> deleteProduct(int id) =>
      _guard(() => _remote.deleteProduct(id));

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on ServerException catch (e) {
      throw Failure(e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw Failure(e.message);
    }
  }
}
