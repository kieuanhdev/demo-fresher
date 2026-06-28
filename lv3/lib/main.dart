import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/di/initial_binding.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';

import 'core/localization/app_translations.dart';
import 'core/localization/language_enum.dart';
import 'core/localization/locale_keys.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await AppTranslations.loadTranslations();
  runApp(const SdsApp());
}

class SdsApp extends StatelessWidget {
  const SdsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SDS Mobile',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: LanguageEnum.loadLocale,
      supportedLocales: LanguageEnum.locales,
      fallbackLocale: LanguageEnum.english.locale,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeService().theme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      // Hiệu ứng chuyển trang toàn cục cho mọi Get.toNamed / Get.offAllNamed.
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
