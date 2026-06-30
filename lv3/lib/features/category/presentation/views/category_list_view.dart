import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../generated/locales.g.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_controller.dart';

class CategoryListView extends BaseView<CategoryController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: LocaleKeys.categories_title.tr,
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
        label: Text(LocaleKeys.common_add.tr),
      ),
      body: stateBuilder(
        isEmpty: () => controller.categories.isEmpty,
        onRetry: controller.fetch,
        empty: EmptyStateView(
          icon: Icons.category_outlined,
          title: LocaleKeys.categories_noCategories.tr,
          subtitle: '',
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
            child: Icon(Icons.folder_rounded, color: AppColors.primary),
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
            icon: Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () => Get.toNamed(AppRoutes.categoryForm, arguments: c),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () => _confirmDelete(c),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Category c) {
    AppDialogs.showConfirm(
      title: LocaleKeys.categories_deleteCategory.tr,
      message: LocaleKeys.categories_deleteConfirm.trParams({'name': c.name}),
      textConfirm: LocaleKeys.common_delete.tr,
      onConfirm: () => controller.delete(c.id),
    );
  }
}
