import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_controller.dart';

class ProductFormView extends StatefulWidget {
  const ProductFormView({super.key});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final ProductController controller = Get.find<ProductController>();
  final _formKey = GlobalKey<FormState>();
  late final Product? _editing = Get.arguments as Product?;

  late final _nameCtrl = TextEditingController(text: _editing?.name ?? '');
  late final _codeCtrl = TextEditingController(text: _editing?.code ?? '');
  late final _priceCtrl =
      TextEditingController(text: _editing?.price.toString() ?? '');
  late final _stockCtrl =
      TextEditingController(text: _editing?.stock.toString() ?? '');
  late final _descCtrl =
      TextEditingController(text: _editing?.description ?? '');
  late final _imageCtrl = TextEditingController(text: _editing?.image ?? '');
  late final _categoryId = RxnInt(_editing?.categoryId);

  bool get _isEdit => _editing != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: _isEdit ? 'Edit product' : 'New product',
      bottomBar: FormSaveBar(
        child: Obx(
          () => AppButton(
            label: _isEdit ? 'Update' : 'Create',
            loading: controller.isSaving.value,
            onPressed: _submit,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _label('Basic info'),
                AppInput(
                    controller: _nameCtrl, label: LocaleKeys.common_name.tr, required: true),
                AppDimens.gap12,
                AppInput(
                    controller: _codeCtrl, label: LocaleKeys.common_code.tr, required: true),
                _label('Pricing & stock'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppInput(
                        controller: _priceCtrl,
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
                        controller: _stockCtrl,
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
                _label('More details'),
                Obx(() {
                  final cats = controller.categories;
                  final ids = cats.map((c) => c.id).toSet();
                  final current =
                      ids.contains(_categoryId.value) ? _categoryId.value : null;
                  return DropdownButtonFormField<int?>(
                    value: current,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Category *'),
                    items: cats
                        .map((c) => DropdownMenuItem<int?>(
                              value: c.id,
                              child: Text(c.name,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) => _categoryId.value = v,
                    validator: (v) => v == null ? 'Required' : null,
                  );
                }),
                AppDimens.gap12,
                AppInput(controller: _imageCtrl, label: LocaleKeys.common_image_url.tr),
                AppDimens.gap12,
                AppInput(
                    controller: _descCtrl, label: LocaleKeys.common_description.tr, maxLines: 3),
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
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v) == null) return 'Invalid number';
    return null;
  }

  String? _intValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (int.tryParse(v) == null) return 'Invalid integer';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final p = Product(
      id: _editing?.id ?? 0,
      name: _nameCtrl.text.trim(),
      code: _codeCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text) ?? 0,
      stock: int.tryParse(_stockCtrl.text) ?? 0,
      categoryId: _categoryId.value ?? 0,
      description: _descCtrl.text.trim(),
      image: _imageCtrl.text.trim(),
    );
    final ok = _isEdit
        ? await controller.updateProduct(_editing!.id, p)
        : await controller.create(p);
    if (ok) Get.back();
  }
}
