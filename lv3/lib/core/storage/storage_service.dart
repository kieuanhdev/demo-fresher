import 'package:get_storage/get_storage.dart';

import '../constants/api_constants.dart';

/// Lớp bọc mỏng trên get_storage để lưu JWT token.
class StorageService {
  final GetStorage _box;
  StorageService(this._box);

  String? get token => _box.read<String>(StorageKeys.token);

  bool get hasToken => (token ?? '').isNotEmpty;

  Future<void> saveToken(String token) => _box.write(StorageKeys.token, token);

  Future<void> clearToken() => _box.remove(StorageKeys.token);
}
