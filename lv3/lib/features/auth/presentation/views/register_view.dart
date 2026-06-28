import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController controller = Get.find<AuthController>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppInput(
                        controller: _userCtrl,
                        label: LocaleKeys.auth_username.tr,
                        prefixIcon: Icons.person_outline,
                        required: true,
                      ),
                      AppDimens.gap16,
                      Obx(
                        () => AppInput(
                          controller: _passCtrl,
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
                          loading: controller.isLoading.value,
                          color: AppColors.primary,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.register(
                                  _userCtrl.text, _passCtrl.text);
                            }
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
