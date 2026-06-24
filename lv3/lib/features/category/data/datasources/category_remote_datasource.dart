import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> createCategory(String name);
  Future<CategoryModel> updateCategory(int id, String name);
  Future<void> deleteCategory(int id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient _client;
  CategoryRemoteDataSourceImpl(this._client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await _client.get(ApiConstants.categories);
    return _extractList(data)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CategoryModel> createCategory(String name) async {
    final data = await _client.post(
      ApiConstants.categories,
      data: {'name': name},
    );
    return CategoryModel.fromJson(_extractObject(data, fallbackName: name));
  }

  @override
  Future<CategoryModel> updateCategory(int id, String name) async {
    final data = await _client.put(
      ApiConstants.categoryById(id),
      data: {'name': name},
    );
    final obj = _extractObject(data, fallbackName: name);
    obj['id'] ??= id;
    return CategoryModel.fromJson(obj);
  }

  @override
  Future<void> deleteCategory(int id) =>
      _client.delete(ApiConstants.categoryById(id));

  /// Danh sách có thể là array ở cấp cao nhất hoặc nằm trong `data`/`categories`/`items`.
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final inner = data['data'] ?? data['categories'] ?? data['items'];
      if (inner is List) return inner;
      if (inner is Map && inner['items'] is List) return inner['items'] as List;
    }
    return const [];
  }

  Map<String, dynamic> _extractObject(dynamic data,
      {required String fallbackName}) {
    if (data is Map) {
      final inner = data['data'];
      if (inner is Map) return Map<String, dynamic>.from(inner);
      if (data.containsKey('id') || data.containsKey('name')) {
        return Map<String, dynamic>.from(data);
      }
    }
    return {'name': fallbackName};
  }
}
