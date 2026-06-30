import 'package:get/get.dart';

import '../../../category/data/datasources/category_remote_datasource.dart';
import '../../../category/data/repositories/category_repository_impl.dart';
import '../../../category/domain/repositories/category_repository.dart';
import '../../../category/domain/usecases/category_usecases.dart';
import '../../../category/presentation/controllers/category_controller.dart';

import '../../../product/data/datasources/product_remote_datasource.dart';
import '../../../product/data/repositories/product_repository_impl.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../../../product/domain/usecases/product_usecases.dart';
import '../../../product/presentation/controllers/product_controller.dart';

/// Đảm bảo các controller cho những tab của shell tồn tại trước khi các tab được build.
/// (ShellController + CartController được đăng ký vĩnh viễn trong
/// InitialBinding.)
class HomeShellBinding extends Bindings {
  @override
  void dependencies() {
    // Category dependencies
    Get.lazyPut<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<CategoryRepository>(() => CategoryRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetCategoriesUseCase(Get.find()));
    Get.lazyPut(() => CreateCategoryUseCase(Get.find()));
    Get.lazyPut(() => UpdateCategoryUseCase(Get.find()));
    Get.lazyPut(() => DeleteCategoryUseCase(Get.find()));

    // Product dependencies
    Get.lazyPut<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<ProductRepository>(() => ProductRepositoryImpl(Get.find()));
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
    Get.lazyPut(
      () => CategoryController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      ),
    );
  }
}
