import '../entities/auth_token.dart';

abstract class AuthRepository {
  Future<AuthToken> login(String username, String password);

  /// Đăng ký; trả về thông báo từ server.
  Future<String> register(String username, String password);

  Future<void> logout();

  bool get isLoggedIn;
}
