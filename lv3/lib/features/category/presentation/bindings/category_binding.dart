import 'package:get/get.dart';

import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/category_usecases.dart';
import '../controllers/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryRemoteDataSource>(
        () => CategoryRemoteDataSourceImpl(Get.find()));
    Get.lazyPut<CategoryRepository>(
        () => CategoryRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetCategoriesUseCase(Get.find()));
    Get.lazyPut(() => CreateCategoryUseCase(Get.find()));
    Get.lazyPut(() => UpdateCategoryUseCase(Get.find()));
    Get.lazyPut(() => DeleteCategoryUseCase(Get.find()));

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
