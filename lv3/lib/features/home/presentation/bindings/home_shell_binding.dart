import 'package:get/get.dart';

import '../../../category/presentation/controllers/category_controller.dart';
import '../../../product/presentation/controllers/product_controller.dart';

/// Đảm bảo các controller cho những tab của shell tồn tại trước khi các tab được build.
/// (ShellController + CartController được đăng ký vĩnh viễn trong
/// InitialBinding.)
class HomeShellBinding extends Bindings {
  @override
  void dependencies() {
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
