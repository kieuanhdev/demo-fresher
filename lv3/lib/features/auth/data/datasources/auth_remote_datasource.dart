import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String username, String password);
  Future<String> register(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;
  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<String> login(String username, String password) async {
    final data = await _client.post(
      ApiConstants.login,
      data: {'username': username, 'password': password},
    );
    final token = _extractToken(data);
    if (token == null || token.isEmpty) {
      throw const ServerException('Login succeeded but no token returned.');
    }
    return token;
  }

  @override
  Future<String> register(String username, String password) async {
    final data = await _client.post(
      ApiConstants.register,
      data: {'username': username, 'password': password},
    );
    if (data is Map) {
      return (data['message'] ?? 'Registered successfully').toString();
    }
    return 'Registered successfully';
  }

  /// Token có thể nằm ở cấp cao nhất hoặc lồng bên trong `data`/`token`/`access_token`.
  String? _extractToken(dynamic data) {
    if (data is! Map) return null;
    final direct = data['token'] ?? data['access_token'] ?? data['accessToken'];
    if (direct != null) return direct.toString();
    final inner = data['data'];
    if (inner is Map) {
      final t = inner['token'] ?? inner['access_token'] ?? inner['accessToken'];
      return t?.toString();
    }
    return null;
  }
}
