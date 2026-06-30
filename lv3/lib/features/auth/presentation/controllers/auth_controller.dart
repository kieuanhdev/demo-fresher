import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthController extends BaseController {
  final LoginUseCase _loginUc;
  final RegisterUseCase _registerUc;
  final AuthRepository _repo;

  AuthController(this._loginUc, this._registerUc, this._repo);

  final obscure = true.obs;

  // --- UI State for Login ---
  final loginFormKey = GlobalKey<FormState>();
  final loginUserCtrl = TextEditingController();
  final loginPassCtrl = TextEditingController();

  // --- UI State for Register ---
  final registerFormKey = GlobalKey<FormState>();
  final registerUserCtrl = TextEditingController();
  final registerPassCtrl = TextEditingController();

  bool get isLoggedIn => _repo.isLoggedIn;

  void toggleObscure() => obscure.toggle();

  @override
  void onClose() {
    loginUserCtrl.dispose();
    loginPassCtrl.dispose();
    registerUserCtrl.dispose();
    registerPassCtrl.dispose();
    super.onClose();
  }

  Future<void> submitLogin() async {
    if (!loginFormKey.currentState!.validate()) return;
    final username = loginUserCtrl.text;
    final password = loginPassCtrl.text;
    if (!_validate(username, password)) return;
    isShowLoading.value = true;
    try {
      await _loginUc(username.trim(), password);
      Get.offAllNamed(AppRoutes.home);
    } on Failure catch (f) {
      showError(f.message);
    } finally {
      isShowLoading.value = false;
    }
  }

  Future<void> submitRegister() async {
    if (!registerFormKey.currentState!.validate()) return;
    final username = registerUserCtrl.text;
    final password = registerPassCtrl.text;
    if (!_validate(username, password)) return;
    isShowLoading.value = true;
    try {
      final msg = await _registerUc(username.trim(), password);
      Get.back();
      showOk(msg);
    } on Failure catch (f) {
      showError(f.message);
    } finally {
      isShowLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  bool _validate(String username, String password) {
    if (username.trim().isEmpty || password.isEmpty) {
      showError('Username and password are required.');
      return false;
    }
    return true;
  }
}
