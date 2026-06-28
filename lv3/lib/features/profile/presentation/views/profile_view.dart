import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/localization/language_enum.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_service.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(LocaleKeys.profile_title.tr),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserInfo(),
          const SizedBox(height: 24),
          _buildThemeToggle(),
          const Divider(),
          _buildLanguageSelector(),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.danger),
            title: AppText.body(
              LocaleKeys.common_logout.tr,
              color: AppColors.danger,
            ),
            onTap: _authController.logout,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(Icons.person, size: 30, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title('Guest User'),
                const SizedBox(height: 4),
                AppText.body('guest@example.com', color: AppColors.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: AppText.body(LocaleKeys.profile_theme.tr),
      trailing: Obx(() {
        final isDark = ThemeService.isDarkMode.value;
        return Switch(
          value: isDark,
          onChanged: (value) {
            ThemeService().switchTheme();
          },
        );
      }),
    );
  }

  Widget _buildLanguageSelector() {
    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: AppText.body(LocaleKeys.profile_language.tr),
      trailing: DropdownButton<LanguageEnum>(
        value: _getCurrentLanguage(),
        underline: const SizedBox(),
        items: [
          DropdownMenuItem(
            value: LanguageEnum.english,
            child: AppText.body(LocaleKeys.profile_english.tr),
          ),
          DropdownMenuItem(
            value: LanguageEnum.vietnamese,
            child: AppText.body(LocaleKeys.profile_vietnamese.tr),
          ),
        ],
        onChanged: (LanguageEnum? newValue) {
          if (newValue != null) {
            LanguageEnum.changeLanguage(newValue);
          }
        },
      ),
    );
  }

  LanguageEnum _getCurrentLanguage() {
    final locale = Get.locale;
    if (locale?.languageCode == 'vi') {
      return LanguageEnum.vietnamese;
    }
    return LanguageEnum.english;
  }
}
