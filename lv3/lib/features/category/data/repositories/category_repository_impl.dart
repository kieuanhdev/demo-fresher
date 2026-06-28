import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remote;
  CategoryRepositoryImpl(this._remote);

  @override
  Future<List<Category>> getCategories() => _guard(() async {
        final models = await _remote.getCategories();
        return models.map((e) => e.toEntity()).toList();
      });

  @override
  Future<Category> createCategory(String name) => _guard(() async {
        final model = await _remote.createCategory(name);
        return model.toEntity();
      });

  @override
  Future<Category> updateCategory(int id, String name) => _guard(() async {
        final model = await _remote.updateCategory(id, name);
        return model.toEntity();
      });

  @override
  Future<void> deleteCategory(int id) =>
      _guard(() => _remote.deleteCategory(id));

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on ServerException catch (e) {
      throw Failure(e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw Failure(e.message);
    }
  }
}
