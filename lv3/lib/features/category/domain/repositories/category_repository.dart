import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> createCategory(String name);
  Future<Category> updateCategory(int id, String name);
  Future<void> deleteCategory(int id);
}
