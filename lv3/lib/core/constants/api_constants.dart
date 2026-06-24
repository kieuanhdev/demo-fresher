import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Tập trung các hằng số endpoint API + key.
class ApiConstants {
  ApiConstants._();

  static const int _port = 1997;
  static const String _path = '/api/v1';

  /// Giá trị override tùy chọn truyền vào lúc build/run:
  ///   flutter run --dart-define=API_HOST=192.168.1.50
  /// Khi được set, sẽ ưu tiên hơn host tự động dò. Dùng cho thiết bị thật
  /// cùng mạng Wi-Fi (trỏ tới IP LAN của máy PC).
  static const String _hostOverride =
      String.fromEnvironment('API_HOST', defaultValue: '');

  /// Xác định host phù hợp theo từng platform:
  /// - API_HOST override (thiết bị thật): IP LAN của PC, vd 192.168.1.50.
  /// - Android emulator: 10.0.2.2 ánh xạ tới localhost của máy host.
  /// - iOS simulator / web / desktop: localhost dùng trực tiếp được.
  static String get baseUrl {
    final host = _host;
    return 'http://$host:$_port$_path';
  }

  static String get _host {
    if (_hostOverride.isNotEmpty) return _hostOverride;
    if (kIsWeb) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String ping = '/ping';

  // Categories
  static const String categories = '/categories';
  static String categoryById(int id) => '/categories/$id';

  // Products
  static const String products = '/products';
  static String productById(int id) => '/products/$id';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}

/// Các key của get_storage.
class StorageKeys {
  StorageKeys._();
  static const String token = 'auth_token';
}
