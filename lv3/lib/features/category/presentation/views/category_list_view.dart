import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_controller.dart';

class CategoryListView extends BaseView<CategoryController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Categories',
      actions: [
        IconButton(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: controller.fetch,
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_categories',
        onPressed: () => Get.toNamed(AppRoutes.categoryForm),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: stateBuilder(
        isEmpty: () => controller.categories.isEmpty,
        onRetry: controller.fetch,
        empty: const EmptyStateView(
          icon: Icons.category_outlined,
          title: 'No categories yet',
          subtitle: 'Tap Add to create your first category.',
        ),
        content: () => RefreshIndicator(
          onRefresh: controller.fetch,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: controller.categories.length,
            separatorBuilder: (_, __) => AppDimens.gap12,
            itemBuilder: (_, i) => _tile(controller.categories[i]),
          ),
        ),
      ),
    );
  }

  Widget _tile(Category c) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.folder_rounded, color: AppColors.primary),
          ),
          AppDimens.gap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(c.name),
                AppDimens.gap4,
                AppText.caption('ID: ${c.id}'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () => Get.toNamed(AppRoutes.categoryForm, arguments: c),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () => _confirmDelete(c),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Category c) {
    Get.defaultDialog(
      title: 'Delete category',
      titleStyle: const TextStyle(fontWeight: FontWeight.w700),
      middleText: 'Delete "${c.name}"?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.danger,
      onConfirm: () {
        Get.back();
        controller.delete(c.id);
      },
    );
  }
}
