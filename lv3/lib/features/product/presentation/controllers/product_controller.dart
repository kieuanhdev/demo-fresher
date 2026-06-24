import 'package:get/get.dart';

import '../../../../core/base/base_list_controller.dart';
import '../../../../core/error/failures.dart';
import '../../../category/domain/entities/category.dart';
import '../../../category/domain/usecases/category_usecases.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_page.dart';
import '../../domain/usecases/product_usecases.dart';

class ProductController extends BaseListController<Product> {
  final GetProductsUseCase _getUc;
  final CreateProductUseCase _createUc;
  final UpdateProductUseCase _updateUc;
  final DeleteProductUseCase _deleteUc;
  final GetCategoriesUseCase _getCategoriesUc;

  ProductController(
    this._getUc,
    this._createUc,
    this._updateUc,
    this._deleteUc,
    this._getCategoriesUc,
  );

  final categories = <Category>[].obs;
  final selectedCategoryId = RxnInt();

  // Alias tiện lợi để code ở view dễ đọc hơn.
  RxList<Product> get products => items;

  @override
  Future<void> onFirstLoad() => loadCategories();

  @override
  Future<PageResult<Product>> fetchPage(int page) async {
    final pg = await _getUc(
      ProductQuery(
        page: page,
        limit: pageSize,
        categoryId: selectedCategoryId.value,
        keyword: keyword.value.trim().isEmpty ? null : keyword.value.trim(),
      ),
    );
    return PageResult(pg.items, pg.total);
  }

  Future<void> loadCategories() async {
    try {
      categories.value = await _getCategoriesUc();
    } on Failure {
      // Dropdown lọc là tùy chọn; bỏ qua lỗi một cách thầm lặng.
    }
  }

  void onCategoryFilter(int? categoryId) {
    selectedCategoryId.value = categoryId;
    refreshList();
  }

  void clearFilters() {
    keyword.value = '';
    selectedCategoryId.value = null;
    refreshList();
  }

  String categoryName(int id) =>
      categories.firstWhereOrNull((c) => c.id == id)?.name ?? '-';

  Future<bool> create(Product p) => runMutation(() async {
        await _createUc(p);
        await refreshList();
      });

  Future<bool> updateProduct(int id, Product p) => runMutation(() async {
        await _updateUc(id, p);
        final i = items.indexWhere((e) => e.id == id);
        if (i != -1) items[i] = p.copyWith(id: id);
      });

  Future<void> delete(int id) async {
    try {
      await _deleteUc(id);
      items.removeWhere((e) => e.id == id);
      if (total > 0) total--;
      showOk('Product deleted');
    } on Failure catch (f) {
      showError(f.message);
    }
  }
}
