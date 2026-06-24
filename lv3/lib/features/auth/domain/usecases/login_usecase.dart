import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<AuthToken> call(String username, String password) =>
      _repo.login(username, password);
}
