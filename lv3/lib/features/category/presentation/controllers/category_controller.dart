import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/category_usecases.dart';

class CategoryController extends BaseController {
  final GetCategoriesUseCase _getUc;
  final CreateCategoryUseCase _createUc;
  final UpdateCategoryUseCase _updateUc;
  final DeleteCategoryUseCase _deleteUc;

  CategoryController(
    this._getUc,
    this._createUc,
    this._updateUc,
    this._deleteUc,
  );

  final categories = <Category>[].obs;

  bool get isEmpty => categories.isEmpty;

  // --- Form State ---
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  Category? editingCategory;
  bool get isEdit => editingCategory != null;

  void initForm(Category? category) {
    editingCategory = category;
    nameCtrl.text = category?.name ?? '';
  }

  Future<bool> submitForm() async {
    if (!formKey.currentState!.validate()) return false;
    final name = nameCtrl.text.trim();
    final ok = isEdit
        ? await updateCategory(editingCategory!.id, name)
        : await createCategory(name);
    return ok;
  }

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    super.onClose();
  }

  Future<void> fetch() async {
    final result = await runGuarded(() => _getUc());
    if (result != null) categories.value = result;
  }

  Future<bool> createCategory(String name) => runMutation(() async {
        final c = await _createUc(name);
        categories.insert(0, c);
      });

  Future<bool> updateCategory(int id, String name) => runMutation(() async {
        final updated = await _updateUc(id, name);
        final i = categories.indexWhere((e) => e.id == id);
        if (i != -1) categories[i] = updated;
      });

  Future<void> delete(int id) async {
    try {
      await _deleteUc(id);
      categories.removeWhere((e) => e.id == id);
      showOk('Category deleted');
    } on Failure catch (f) {
      showError(f.message);
    }
  }
}
