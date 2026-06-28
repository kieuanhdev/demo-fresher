import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Map<String, String> _vi = {};
  static final Map<String, String> _en = {};

  static Future<void> loadTranslations() async {
    final viStr = await rootBundle.loadString('assets/locales/vi_VN.json');
    final enStr = await rootBundle.loadString('assets/locales/en_US.json');

    _vi.addAll(_flatten(jsonDecode(viStr) as Map<String, dynamic>));
    _en.addAll(_flatten(jsonDecode(enStr) as Map<String, dynamic>));
  }

  static Map<String, String> _flatten(Map<String, dynamic> json, [String prefix = '']) {
    final Map<String, String> result = {};
    json.forEach((key, value) {
      final newKey = prefix.isEmpty ? key : '${prefix}_$key';
      if (value is Map<String, dynamic>) {
        result.addAll(_flatten(value, newKey));
      } else {
        result[newKey] = value.toString();
      }
    });
    return result;
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'vi_VN': _vi,
        'en_US': _en,
      };
}
