import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

enum LanguageEnum {
  vietnamese('vi', 'VN'),
  english('en', 'US');

  final String languageCode;
  final String? countryCode;

  const LanguageEnum(this.languageCode, this.countryCode);

  Locale get locale => Locale(languageCode, countryCode);

  static List<Locale> get locales => values.map((e) => e.locale).toList();

  static Locale get loadLocale {
    final box = GetStorage();
    final String? lang = box.read('languageKey');
    if (lang == 'vi_VN') {
      return LanguageEnum.vietnamese.locale;
    } else if (lang == 'en_US') {
      return LanguageEnum.english.locale;
    }
    // Default to English
    return LanguageEnum.english.locale;
  }
}
