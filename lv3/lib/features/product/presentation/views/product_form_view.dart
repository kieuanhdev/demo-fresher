import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../generated/locales.g.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_controller.dart';

class ProductFormView extends GetView<ProductController> {
  ProductFormView({super.key}) {
    controller.initForm(Get.arguments as Product?);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: controller.isEdit ? LocaleKeys.products_editProduct.tr : LocaleKeys.products_newProduct.tr,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _label(LocaleKeys.products_basicInfo.tr),
                AppInput(
                    controller: controller.nameCtrl, label: LocaleKeys.common_name.tr, required: true),
                AppDimens.gap12,
                AppInput(
                    controller: controller.codeCtrl, label: LocaleKeys.common_code.tr, required: true),
                _label(LocaleKeys.products_pricingStock.tr),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppInput(
                        controller: controller.priceCtrl,
                        label: LocaleKeys.common_price.tr,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'))
                        ],
                        validator: _numValidator,
                      ),
                    ),
                    AppDimens.gap12,
                    Expanded(
                      child: AppInput(
                        controller: controller.stockCtrl,
                        label: LocaleKeys.common_stock.tr,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: _intValidator,
                      ),
                    ),
                  ],
                ),
                _label(LocaleKeys.products_moreDetails.tr),
                Obx(() {
                  final cats = controller.categories;
                  final ids = cats.map((c) => c.id).toSet();
                  final current =
                      ids.contains(controller.formCategoryId.value) ? controller.formCategoryId.value : null;
                  return DropdownButtonFormField<int?>(
                    value: current,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: '${LocaleKeys.categories_title.tr} *'),
                    items: cats
                        .map((c) => DropdownMenuItem<int?>(
                              value: c.id,
                              child: Text(c.name,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) => controller.formCategoryId.value = v,
                    validator: (v) => v == null ? LocaleKeys.common_required.tr : null,
                  );
                }),
                AppDimens.gap12,
                AppInput(controller: controller.imageCtrl, label: LocaleKeys.common_image_url.tr),
                AppDimens.gap12,
                AppInput(
                    controller: controller.descCtrl, label: LocaleKeys.common_description.tr, maxLines: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: AppText.caption(text.toUpperCase()),
      );

  String? _numValidator(String? v) {
    if (v == null || v.trim().isEmpty) return LocaleKeys.common_required.tr;
    if (double.tryParse(v) == null) return LocaleKeys.common_invalid_number.tr;
    return null;
  }

  String? _intValidator(String? v) {
    if (v == null || v.trim().isEmpty) return LocaleKeys.common_required.tr;
    if (int.tryParse(v) == null) return LocaleKeys.common_invalid_integer.tr;
    return null;
  }


}
