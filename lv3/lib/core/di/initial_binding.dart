import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../network/dio_client.dart';
import '../storage/storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/cart/presentation/controllers/cart_controller.dart';
import '../../features/home/presentation/controllers/shell_controller.dart';
import '../../features/category/data/datasources/category_remote_datasource.dart';
import '../../features/category/data/repositories/category_repository_impl.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/category/domain/usecases/category_usecases.dart';
import '../../features/product/data/datasources/product_remote_datasource.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/product_usecases.dart';

/// Đăng ký tất cả dependency cross-cutting + domain một lần khi khởi động.
/// Controller được tạo lazy bởi các binding theo từng trang.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    final storage = StorageService(GetStorage());
    Get.put<StorageService>(storage, permanent: true);
    Get.put<DioClient>(DioClient(storage), permanent: true);
    final dio = Get.find<DioClient>();

    // Auth
    Get.put<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(dio),
        permanent: true);
    Get.put<AuthRepository>(
      AuthRepositoryImpl(Get.find(), storage),
      permanent: true,
    );
    Get.put(LoginUseCase(Get.find()), permanent: true);
    Get.put(RegisterUseCase(Get.find()), permanent: true);
    // AuthController là permanent để logout hoạt động từ bất kỳ đâu.
    Get.put(
      AuthController(Get.find(), Get.find(), Get.find()),
      permanent: true,
    );

    // Shell + Cart (toàn cục, tồn tại qua việc chuyển tab & điều hướng)
    Get.put(ShellController(), permanent: true);
    Get.put(CartController(), permanent: true);

    // Category
    Get.put<CategoryRemoteDataSource>(CategoryRemoteDataSourceImpl(dio),
        permanent: true);
    Get.put<CategoryRepository>(
      CategoryRepositoryImpl(Get.find()),
      permanent: true,
    );
    Get.put(GetCategoriesUseCase(Get.find()), permanent: true);
    Get.put(CreateCategoryUseCase(Get.find()), permanent: true);
    Get.put(UpdateCategoryUseCase(Get.find()), permanent: true);
    Get.put(DeleteCategoryUseCase(Get.find()), permanent: true);

    // Product
    Get.put<ProductRemoteDataSource>(ProductRemoteDataSourceImpl(dio),
        permanent: true);
    Get.put<ProductRepository>(
      ProductRepositoryImpl(Get.find()),
      permanent: true,
    );
    Get.put(GetProductsUseCase(Get.find()), permanent: true);
    Get.put(CreateProductUseCase(Get.find()), permanent: true);
    Get.put(UpdateProductUseCase(Get.find()), permanent: true);
    Get.put(DeleteProductUseCase(Get.find()), permanent: true);
  }
}
