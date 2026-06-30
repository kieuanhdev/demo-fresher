import 'package:get/get.dart';

import '../../../category/data/datasources/category_remote_datasource.dart';
import '../../../category/data/repositories/category_repository_impl.dart';
import '../../../category/domain/repositories/category_repository.dart';
import '../../../category/domain/usecases/category_usecases.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/product_usecases.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // Category dependencies (needed for product controller)
    Get.lazyPut<CategoryRemoteDataSource>(
        () => CategoryRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<CategoryRepository>(
        () => CategoryRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetCategoriesUseCase(Get.find()));

    // Product dependencies
    Get.lazyPut<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetProductsUseCase(Get.find()));
    Get.lazyPut(() => CreateProductUseCase(Get.find()));
    Get.lazyPut(() => UpdateProductUseCase(Get.find()));
    Get.lazyPut(() => DeleteProductUseCase(Get.find()));

    Get.lazyPut(
      () => ProductController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
  }
}
