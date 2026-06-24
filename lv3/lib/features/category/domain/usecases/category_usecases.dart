import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _repo;
  GetCategoriesUseCase(this._repo);
  Future<List<Category>> call() => _repo.getCategories();
}

class CreateCategoryUseCase {
  final CategoryRepository _repo;
  CreateCategoryUseCase(this._repo);
  Future<Category> call(String name) => _repo.createCategory(name);
}

class UpdateCategoryUseCase {
  final CategoryRepository _repo;
  UpdateCategoryUseCase(this._repo);
  Future<Category> call(int id, String name) => _repo.updateCategory(id, name);
}

class DeleteCategoryUseCase {
  final CategoryRepository _repo;
  DeleteCategoryUseCase(this._repo);
  Future<void> call(int id) => _repo.deleteCategory(id);
}
