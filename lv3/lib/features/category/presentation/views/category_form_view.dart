import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_controller.dart';

class CategoryFormView extends StatefulWidget {
  const CategoryFormView({super.key});

  @override
  State<CategoryFormView> createState() => _CategoryFormViewState();
}

class _CategoryFormViewState extends State<CategoryFormView> {
  final CategoryController controller = Get.find<CategoryController>();
  final _formKey = GlobalKey<FormState>();
  late final Category? _editing = Get.arguments as Category?;
  late final _nameCtrl = TextEditingController(text: _editing?.name ?? '');

  bool get _isEdit => _editing != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: _isEdit ? 'Edit category' : 'New category',
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
            child: AppInput(
              controller: _nameCtrl,
              label: 'Name',
              required: true,
              autofocus: true,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final ok = _isEdit
        ? await controller.updateCategory(_editing!.id, name)
        : await controller.create(name);
    if (ok) Get.back();
  }
}
