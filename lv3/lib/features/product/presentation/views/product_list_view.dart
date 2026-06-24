import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_controller.dart';

class ProductListView extends BaseView<ProductController> {
  ProductListView({super.key});

  final _cart = Get.find<CartController>();

  /// Kích hoạt load-more khi cuộn gần tới đáy. Dùng qua
  /// [NotificationListener] để không tạo/rò rỉ ScrollController trong build.
  bool _onScroll(ScrollNotification n) {
    if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
      controller.loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Products',
      actions: [
        IconButton(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: controller.refreshList,
        ),
        IconButton(
          tooltip: 'Logout',
          icon: const Icon(Icons.logout_rounded),
          onPressed: _confirmLogout,
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_products',
        onPressed: () => Get.toNamed(AppRoutes.productForm),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: Column(
        children: [
          _filters(),
          Expanded(
            child: stateBuilder(
              isEmpty: () => controller.products.isEmpty,
              onRetry: controller.refreshList,
              empty: const EmptyStateView(
                icon: Icons.inventory_2_outlined,
                title: 'No products found',
                subtitle: 'Try adjusting filters or add a new product.',
              ),
              content: () => RefreshIndicator(
                onRefresh: controller.refreshList,
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScroll,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                    itemCount: controller.products.length + 1,
                    separatorBuilder: (_, __) => AppDimens.gap12,
                    itemBuilder: (_, i) {
                      if (i == controller.products.length) return _footer();
                      return FadeSlideIn(
                        index: i,
                        child: _tile(controller.products[i]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: controller.search,
            decoration: const InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search_rounded),
              isDense: true,
            ),
          ),
          AppDimens.gap12,
          SizedBox(
            height: 36,
            child: Obx(() {
              final cats = controller.categories;
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip('All', null),
                  ...cats.map((c) => _chip(c.name, c.id)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, int? id) {
    return Obx(() {
      final selected = controller.selectedCategoryId.value == id;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          showCheckmark: false,
          labelStyle: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.primary,
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (_) => controller.onCategoryFilter(id),
        ),
      );
    });
  }

  Widget _footer() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (!controller.hasMore && controller.products.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: AppText.caption('— No more products —')),
        );
      }
      return const SizedBox(height: 8);
    });
  }

  Widget _tile(Product p) {
    final hasImage = p.image != null && p.image!.isNotEmpty;
    return AppCard(
      onTap: () => Get.toNamed(AppRoutes.productForm, arguments: p),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              width: 56,
              color: AppColors.surfaceMuted,
              child: hasImage
                  ? Image.network(
                      p.image!,
                      fit: BoxFit.cover,
                      // Decode ở khoảng kích thước hiển thị (56dp @3x) thay vì full res.
                      cacheWidth: 168,
                      cacheHeight: 168,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.inventory_2_rounded,
                          color: AppColors.textMuted),
                    )
                  : const Icon(Icons.inventory_2_rounded,
                      color: AppColors.textMuted),
            ),
          ),
          AppDimens.gap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(p.name),
                AppDimens.gap4,
                AppText.caption('Code: ${p.code}  •  Stock: ${p.stock}'),
                AppDimens.gap8,
                Row(
                  children: [
                    AppText.title(p.price.toCurrency(),
                        color: AppColors.primary),
                    AppDimens.gap8,
                    _categoryTag(controller.categoryName(p.categoryId)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppColors.textMuted),
                onSelected: (v) {
                  if (v == 'edit') {
                    Get.toNamed(AppRoutes.productForm, arguments: p);
                  } else if (v == 'delete') {
                    _confirmDelete(p);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
              _addToCartBtn(p),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addToCartBtn(Product p) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _addToCart(p),
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.add_shopping_cart_rounded,
              color: Colors.white, size: 20),
        ),
      ),
    );
  }

  void _addToCart(Product p) {
    _cart.add(p);
    Get.snackbar(
      'Added to cart',
      p.name,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.textPrimary.withValues(alpha: 0.92),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
    );
  }

  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Logout',
      titleStyle: const TextStyle(fontWeight: FontWeight.w700),
      middleText: 'Are you sure you want to log out?',
      textCancel: 'Cancel',
      textConfirm: 'Logout',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () {
        Get.back();
        Get.find<AuthController>().logout();
      },
    );
  }

  Widget _categoryTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText.caption(label),
    );
  }

  void _confirmDelete(Product p) {
    Get.defaultDialog(
      title: 'Delete product',
      titleStyle: const TextStyle(fontWeight: FontWeight.w700),
      middleText: 'Delete "${p.name}"?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () {
        Get.back();
        controller.delete(p.id);
      },
    );
  }
}
