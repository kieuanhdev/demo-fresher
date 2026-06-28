import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  static final _storage = GetStorage();
  static final _key = 'isDarkMode';

  static final RxBool isDarkMode = _loadThemeFromStorage().obs;

  /// Lấy theme mode đang được lưu
  ThemeMode get theme {
    return isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }

  static bool _loadThemeFromStorage() {
    return _storage.read<bool>(_key) ?? false;
  }

  /// Thay đổi theme giữa Light và Dark
  void switchTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToStorage(isDarkMode.value);
    
    // Cập nhật toàn bộ app ngay lập tức (không delay) để màu sắc đồng bộ
    Get.forceAppUpdate();
  }

  void _saveThemeToStorage(bool isDark) {
    _storage.write(_key, isDark);
  }
}
