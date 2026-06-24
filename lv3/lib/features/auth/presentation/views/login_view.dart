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
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ValidationMixin {
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _logo(),
                const SizedBox(height: 28),
                AppText.display('Welcome back'),
                AppDimens.gap8,
                AppText.body('Sign in to continue to your account'),
                const SizedBox(height: AppDimens.space32),
                AppInput(
                  controller: _userCtrl,
                  label: 'Username',
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
                    controller: _passCtrl,
                    label: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscure: controller.obscure.value,
                    required: true,
                    validator: compose([
                      requiredField('Enter your password'),
                      minLength(6),
                    ]),
                    suffix: IconButton(
                      icon: Icon(controller.obscure.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: controller.toggleObscure,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.space24),
                Obx(
                  () => AppButton(
                    label: 'Login',
                    loading: controller.isLoading.value,
                    onPressed: () {
                      context.hideKeyboard();
                      if (_formKey.currentState!.validate()) {
                        controller.login(_userCtrl.text, _passCtrl.text);
                      }
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
                      child: const Text('Register'),
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
      child: const Icon(Icons.storefront_rounded, size: 32, color: Colors.white),
    );
  }
}
