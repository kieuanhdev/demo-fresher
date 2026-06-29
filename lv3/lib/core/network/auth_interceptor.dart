import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../constants/api_constants.dart';
import '../routes/app_routes.dart';
import '../storage/storage_service.dart';

/// Gắn bearer token vào mọi request; khi gặp 401 thì xóa token và buộc
/// người dùng quay lại màn hình login (session hết hạn/không hợp lệ).
class AuthInterceptor extends Interceptor {
  final StorageService _storage;
  AuthInterceptor(this._storage);

  // Các endpoint auth trả về 401 một cách hợp lệ (sai thông tin đăng nhập). Không
  // coi đó là session hết hạn — để màn hình hiển thị lỗi inline.
  static const _authPaths = {ApiConstants.login, ApiConstants.register};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401 && !_isAuthPath(response.requestOptions.path)) {
      _storage.clearToken();
      _redirectToLogin();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && !_isAuthPath(err.requestOptions.path)) {
      _storage.clearToken();
      _redirectToLogin();
    }
    handler.next(err);
  }

  bool _isAuthPath(String path) {
    return _authPaths.any(path.endsWith);
  }

  void _redirectToLogin() {
    final current = Get.currentRoute;
    if (current == AppRoutes.login || current == AppRoutes.splash) return;
    Get.offAllNamed(AppRoutes.login);
    Get.snackbar(
      'Phiên đăng nhập hết hạn',
      'Vui lòng đăng nhập lại.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
