import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../error/failures.dart';
import '../theme/app_colors.dart';

/// Lớp cơ sở cho mọi GetxController.
///
/// Tập trung quản lý state loading / saving / error và các snackbar success/error
/// để các controller tính năng không phải lặp lại cùng một đoạn boilerplate.
/// Phản chiếu ý tưởng `BaseGetxController` từ tài liệu hướng dẫn kiến trúc.
abstract class BaseController extends GetxController {
  /// Cờ spinner cho toàn màn hình / lần tải đầu tiên.
  final isLoading = false.obs;

  /// Cờ báo đang thực hiện mutation (create / update / delete).
  final isSaving = false.obs;

  /// Thông báo lỗi của lần tải gần nhất (null khi không có lỗi).
  final error = RxnString();

  /// Chạy [task], theo dõi [isLoading] và bắt các failure vào [error].
  /// Trả về kết quả của task, hoặc null khi thất bại.
  Future<T?> runGuarded<T>(
    Future<T> Function() task, {
    bool track = true,
  }) async {
    if (track) {
      isLoading.value = true;
      error.value = null;
    }
    try {
      return await task();
    } on Failure catch (f) {
      error.value = f.message;
      return null;
    } catch (e) {
      error.value = e.toString();
      return null;
    } finally {
      if (track) isLoading.value = false;
    }
  }

  /// Chạy một mutation, theo dõi [isSaving] và hiển thị snackbar.
  /// Trả về true khi thành công.
  Future<bool> runMutation(
    Future<void> Function() task, {
    String success = 'Saved',
  }) async {
    isSaving.value = true;
    try {
      await task();
      if (success.isNotEmpty) showOk(success);
      return true;
    } on Failure catch (f) {
      showError(f.message);
      return false;
    } catch (e) {
      showError(e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void showOk(String message) => _snack('Success', message, AppColors.success);

  void showError(String message) =>
      _snack('Error', message, AppColors.danger);

  void _snack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      backgroundColor: color.withValues(alpha: 0.95),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: Icon(
        color == AppColors.success
            ? Icons.check_circle_rounded
            : Icons.error_rounded,
        color: Colors.white,
      ),
    );
  }
}
