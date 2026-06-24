import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<String> call(String username, String password) =>
      _repo.register(username, password);
}
