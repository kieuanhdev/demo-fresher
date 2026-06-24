import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';
import '../storage/storage_service.dart';
import 'auth_interceptor.dart';

/// Bao bọc Dio. Trả về JSON đã decode; ném ra exception có kiểu khi thất bại.
class DioClient {
  late final Dio _dio;

  DioClient(StorageService storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
        // Không tự ném lỗi với 4xx/5xx; chúng ta tự map lỗi.
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    _dio.interceptors.add(AuthInterceptor(storage));
    // Chỉ log body khi debug — tránh lộ token/payload ở bản release.
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _request(() => _dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {dynamic data}) =>
      _request(() => _dio.post(path, data: data));

  Future<dynamic> put(String path, {dynamic data}) =>
      _request(() => _dio.put(path, data: data));

  Future<dynamic> delete(String path) => _request(() => _dio.delete(path));

  Future<dynamic> _request(Future<Response<dynamic>> Function() run) async {
    try {
      final res = await run();
      final code = res.statusCode ?? 0;
      if (code >= 200 && code < 300) return res.data;
      if (code == 401) {
        throw UnauthorizedException(_message(res.data) ?? 'Unauthorized');
      }
      throw ServerException(
        _message(res.data) ?? 'Request failed',
        statusCode: code,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Network error. Check your connection.');
      }
      throw ServerException(
        _message(e.response?.data) ?? e.message ?? 'Unexpected error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Server thường trả về {"message": "..."} hoặc {"error": "..."}.
  String? _message(dynamic data) {
    if (data is Map) {
      return (data['message'] ?? data['error'] ?? data['msg'])?.toString();
    }
    return null;
  }
}
