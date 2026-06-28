import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  /// Lấy theme mode đang được lưu
  ThemeMode get theme {
    return _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;
  }

  bool _loadThemeFromStorage() {
    return _storage.read<bool>(_key) ?? false;
  }

  /// Thay đổi theme giữa Light và Dark
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromStorage() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToStorage(!_loadThemeFromStorage());
  }

  void _saveThemeToStorage(bool isDarkMode) {
    _storage.write(_key, isDarkMode);
  }
}
