import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../generated/locales.g.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: LocaleKeys.auth_createAccount.tr,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppDimens.gap8,
              AppText.heading('Join SDS Mobile'),
              AppDimens.gap8,
              AppText.body('Fill in your details to get started'),
              const SizedBox(height: AppDimens.space24),
              AppCard(
                padding: const EdgeInsets.all(22),
                radius: AppDimens.radiusXl,
                child: Form(
                  key: controller.registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppInput(
                        controller: controller.registerUserCtrl,
                        label: LocaleKeys.auth_username.tr,
                        prefixIcon: Icons.person_outline,
                        required: true,
                      ),
                      AppDimens.gap16,
                      Obx(
                        () => AppInput(
                          controller: controller.registerPassCtrl,
                          label: LocaleKeys.auth_password.tr,
                          prefixIcon: Icons.lock_outline,
                          obscure: controller.obscure.value,
                          suffix: IconButton(
                            icon: Icon(controller.obscure.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: controller.toggleObscure,
                          ),
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Min 6 characters'
                              : null,
                        ),
                      ),
                      AppDimens.gap24,
                      Obx(
                        () => AppButton(
                          label: LocaleKeys.auth_register.tr,
                          loading: controller.isShowLoading.value,
                          color: AppColors.primary,
                          onPressed: () {
                            context.hideKeyboard();
                            controller.submitRegister();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
