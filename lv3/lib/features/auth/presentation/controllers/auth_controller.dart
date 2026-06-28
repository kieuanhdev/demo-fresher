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

  bool get isLoggedIn => _repo.isLoggedIn;

  void toggleObscure() => obscure.toggle();

  Future<void> login(String username, String password) async {
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

  Future<void> register(String username, String password) async {
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
