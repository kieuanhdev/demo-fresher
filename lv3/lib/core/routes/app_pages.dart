import 'package:get/get.dart';

import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/category/presentation/bindings/category_binding.dart';
import '../../features/category/presentation/views/category_form_view.dart';
import '../../features/category/presentation/views/category_list_view.dart';
import '../../features/home/presentation/bindings/home_shell_binding.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/product/presentation/bindings/product_binding.dart';
import '../../features/product/presentation/views/product_form_view.dart';
import '../../features/product/presentation/views/product_list_view.dart';
import '../../features/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.login, page: () => LoginView()),
    GetPage(name: AppRoutes.register, page: () => RegisterView()),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeShellBinding(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoryListView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.categoryForm,
      page: () => CategoryFormView(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => ProductListView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productForm,
      page: () => ProductFormView(),
      binding: ProductBinding(),
    ),
  ];
}
