import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final StorageService _storage;
  AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<AuthToken> login(String username, String password) async {
    try {
      final token = await _remote.login(username, password);
      await _storage.saveToken(token);
      return AuthToken(token);
    } on ServerException catch (e) {
      throw Failure(e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw Failure(e.message);
    }
  }

  @override
  Future<String> register(String username, String password) async {
    try {
      return await _remote.register(username, password);
    } on ServerException catch (e) {
      throw Failure(e.message, statusCode: e.statusCode);
    } on NetworkException catch (e) {
      throw Failure(e.message);
    }
  }

  @override
  Future<void> logout() => _storage.clearToken();

  @override
  bool get isLoggedIn => _storage.hasToken;
}
