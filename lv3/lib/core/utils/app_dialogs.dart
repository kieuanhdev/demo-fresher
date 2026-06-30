import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/locales.g.dart';
import '../theme/app_colors.dart';

class AppDialogs {
  static void showConfirm({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String? textConfirm,
    String? textCancel,
    Color? buttonColor,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.w700),
      middleText: message,
      textCancel: textCancel ?? LocaleKeys.common_cancel.tr,
      textConfirm: textConfirm ?? LocaleKeys.common_confirm.tr,
      confirmTextColor: Colors.white,
      buttonColor: buttonColor ?? AppColors.danger,
      onConfirm: () {
        Get.back();
        onConfirm();
      },
    );
  }

  static void showToast({
    required String title,
    required String message,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    bool isError = false,
  }) {
    final bgColor = isError 
        ? AppColors.danger.withValues(alpha: 0.95) 
        : AppColors.textPrimary.withValues(alpha: 0.92);
    final displayIcon = icon ?? (isError ? Icons.error_outline_rounded : Icons.check_circle_rounded);

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 14,
      duration: duration,
      backgroundColor: bgColor,
      colorText: AppColors.surface,
      icon: Icon(displayIcon, color: AppColors.surface),
    );
  }
}
