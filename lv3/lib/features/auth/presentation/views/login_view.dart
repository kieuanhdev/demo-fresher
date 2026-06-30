import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/mixins/validation_mixin.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/localization/language_enum.dart';
import '../../../../core/theme/theme_service.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> with ValidationMixin {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopActions(),
                const SizedBox(height: 16),
                _logo(),
                const SizedBox(height: 28),
                AppText.display('Welcome back'),
                AppDimens.gap8,
                AppText.body('Sign in to continue to your account'),
                const SizedBox(height: AppDimens.space32),
                AppInput(
                  controller: controller.loginUserCtrl,
                  label: LocaleKeys.auth_username.tr,
                  prefixIcon: Icons.person_outline,
                  required: true,
                  validator: compose([
                    requiredField('Enter your username'),
                    minLength(3),
                  ]),
                ),
                AppDimens.gap16,
                Obx(
                  () => AppInput(
                    controller: controller.loginPassCtrl,
                    label: LocaleKeys.auth_password.tr,
                    prefixIcon: Icons.lock_outline,
                    obscure: controller.obscure.value,
                    required: true,
                    validator: compose([
                      requiredField('Enter your password'),
                      minLength(6),
                    ]),
                    suffix: IconButton(
                      icon: Icon(
                        controller.obscure.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: controller.toggleObscure,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.space24),
                Obx(
                  () => AppButton(
                    label: LocaleKeys.auth_login.tr,
                    loading: controller.isShowLoading.value,
                    onPressed: () {
                      context.hideKeyboard();
                      controller.submitLogin();
                    },
                  ),
                ),
                AppDimens.gap16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText.body("Don't have an account?"),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      child: Text(LocaleKeys.auth_register.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.storefront_rounded,
        size: 32,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTopActions() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<LanguageEnum>(
            value: _getCurrentLanguage(),
            underline: const SizedBox(),
            icon: const Icon(Icons.language_outlined, size: 20),
            items: [
              DropdownMenuItem(
                value: LanguageEnum.english,
                child: AppText.body('EN', fontWeight: FontWeight.w600),
              ),
              DropdownMenuItem(
                value: LanguageEnum.vietnamese,
                child: AppText.body('VN', fontWeight: FontWeight.w600),
              ),
            ],
            onChanged: (LanguageEnum? newValue) {
              if (newValue != null) {
                LanguageEnum.changeLanguage(newValue);
              }
            },
          ),
          const SizedBox(width: 8),
          Obx(() {
            final isDark = ThemeService.isDarkMode.value;
            return IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 24,
              ),
              onPressed: () {
                ThemeService().switchTheme();
              },
            );
          }),
        ],
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
