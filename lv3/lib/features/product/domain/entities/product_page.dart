import 'product.dart';

/// Một trang sản phẩm kèm metadata phân trang.
class ProductPage {
  final List<Product> items;
  final int page;
  final int limit;
  final int total;

  const ProductPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  /// True nếu có khả năng còn trang tiếp theo.
  bool get hasMore => total > page * limit && items.isNotEmpty;
}

/// Tham số truy vấn để liệt kê sản phẩm.
class ProductQuery {
  final int page;
  final int limit;
  final int? categoryId;
  final String? keyword;

  const ProductQuery({
    this.page = 1,
    this.limit = 10,
    this.categoryId,
    this.keyword,
  });

  ProductQuery copyWith({
    int? page,
    int? limit,
    int? categoryId,
    String? keyword,
    bool clearCategory = false,
    bool clearKeyword = false,
  }) {
    return ProductQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      keyword: clearKeyword ? null : (keyword ?? this.keyword),
    );
  }
}
