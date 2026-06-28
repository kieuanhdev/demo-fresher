import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../cart/presentation/views/cart_view.dart';
import '../../../category/presentation/views/category_list_view.dart';
import '../../../product/presentation/views/product_list_view.dart';
import '../controllers/shell_controller.dart';

/// Home shell: chứa các tab chính phía sau một bottom navigation bar.
class HomeView extends StatelessWidget {
  HomeView({super.key});

  final _shell = Get.find<ShellController>();
  final _pages = <Widget>[
    ProductListView(),
    const CategoryListView(),
    const CartView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: _shell.index.value, children: _pages),
      ),
      bottomNavigationBar: _BottomNav(shell: _shell),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final ShellController shell;
  const _BottomNav({required this.shell});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.tint(AppColors.primary),
            labelTextStyle: WidgetStateProperty.resolveWith(
              (states) => TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: states.contains(WidgetState.selected)
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
          ),
          child: NavigationBar(
            height: 64,
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: shell.index.value,
            onDestinationSelected: shell.go,
            destinations: [
              _dest(Icons.inventory_2_outlined, Icons.inventory_2_rounded,
                  LocaleKeys.home_products.tr, shell.index.value == 0),
              _dest(Icons.category_outlined, Icons.category_rounded,
                  LocaleKeys.home_categories.tr, shell.index.value == 1),
              NavigationDestination(
                icon: _cartIcon(cart.count, Icons.shopping_cart_outlined,
                    shell.index.value == 2),
                label: LocaleKeys.home_cart.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  NavigationDestination _dest(
      IconData icon, IconData active, String label, bool selected) {
    final color = selected ? AppColors.primary : AppColors.textMuted;
    return NavigationDestination(
      icon: Icon(selected ? active : icon, color: color),
      label: label,
    );
  }

  Widget _cartIcon(int count, IconData icon, bool selected) {
    final color = selected ? AppColors.primary : AppColors.textMuted;
    final base = Icon(
      selected ? Icons.shopping_cart_rounded : icon,
      color: color,
    );
    if (count == 0) return base;
    return Badge.count(
      count: count,
      backgroundColor: AppColors.danger,
      child: base,
    );
  }
}
