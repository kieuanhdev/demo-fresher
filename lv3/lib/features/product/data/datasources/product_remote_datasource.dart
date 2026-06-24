import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/product_page.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductPageRaw> getProducts(ProductQuery query);
  Future<ProductModel> createProduct(ProductModel p);
  Future<ProductModel> updateProduct(int id, ProductModel p);
  Future<void> deleteProduct(int id);
}

/// Kết quả trang dạng raw, tách rời khỏi việc mapping sang domain entity.
class ProductPageRaw {
  final List<ProductModel> items;
  final int total;
  const ProductPageRaw(this.items, this.total);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _client;
  ProductRemoteDataSourceImpl(this._client);

  @override
  Future<ProductPageRaw> getProducts(ProductQuery query) async {
    final params = <String, dynamic>{
      'page': query.page,
      'limit': query.limit,
    };
    if (query.categoryId != null) params['category_id'] = query.categoryId;
    if ((query.keyword ?? '').isNotEmpty) params['keyword'] = query.keyword;

    final data = await _client.get(ApiConstants.products, query: params);
    final list = _extractList(data)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ProductPageRaw(list, _extractTotal(data, list.length));
  }

  @override
  Future<ProductModel> createProduct(ProductModel p) async {
    final data = await _client.post(ApiConstants.products, data: p.toJson());
    return ProductModel.fromJson(_extractObject(data, p.toJson()));
  }

  @override
  Future<ProductModel> updateProduct(int id, ProductModel p) async {
    final data =
        await _client.put(ApiConstants.productById(id), data: p.toJson());
    final obj = _extractObject(data, p.toJson());
    obj['id'] ??= id;
    return ProductModel.fromJson(obj);
  }

  @override
  Future<void> deleteProduct(int id) =>
      _client.delete(ApiConstants.productById(id));

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final inner = data['data'] ?? data['products'] ?? data['items'];
      if (inner is List) return inner;
      if (inner is Map && inner['items'] is List) return inner['items'] as List;
    }
    return const [];
  }

  /// total/total_items/count — dùng cho phân trang "has more". Mặc định quay về kích thước trang.
  int _extractTotal(dynamic data, int fallback) {
    if (data is Map) {
      final t = data['total'] ??
          data['total_items'] ??
          data['count'] ??
          (data['data'] is Map ? data['data']['total'] : null) ??
          (data['meta'] is Map ? data['meta']['total'] : null);
      if (t is int) return t;
      if (t is num) return t.toInt();
      if (t is String) return int.tryParse(t) ?? fallback;
    }
    return fallback;
  }

  Map<String, dynamic> _extractObject(dynamic data, Map<String, dynamic> sent) {
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map) return Map<String, dynamic>.from(inner);
      if (data.containsKey('id') || data.containsKey('name')) {
        return Map<String, dynamic>.from(data);
      }
    }
    return Map<String, dynamic>.from(sent);
  }
}
