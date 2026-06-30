import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../generated/locales.g.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_controller.dart';

class CategoryFormView extends GetView<CategoryController> {
  CategoryFormView({super.key}) {
    controller.initForm(Get.arguments as Category?);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: controller.isEdit ? LocaleKeys.categories_editCategory.tr : LocaleKeys.categories_newCategory.tr,
      bottomBar: FormSaveBar(
        child: Obx(
          () => AppButton(
            label: controller.isEdit ? LocaleKeys.common_update.tr : LocaleKeys.common_create.tr,
            loading: controller.isLoadingOverlay.value,
            onPressed: () async {
              final ok = await controller.submitForm();
              if (ok) Get.back();
            },
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space20),
          child: Form(
            key: controller.formKey,
            child: AppInput(
              controller: controller.nameCtrl,
              label: LocaleKeys.common_name.tr,
              required: true,
              autofocus: true,
            ),
          ),
        ),
      ),
    );
  }
}
