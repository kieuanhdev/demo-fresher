import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../../generated/locales.g.dart';
import 'package:get/get.dart';
import 'app_text.dart';

/// Placeholder lỗi toàn màn hình kèm nút thử lại.
class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorStateView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 44,
                color: AppColors.danger,
              ),
            ),
            AppDimens.gap16,
            AppText.heading(
              'Something went wrong',
              textAlign: TextAlign.center,
            ),
            AppDimens.gap8,
            AppText.body(message, textAlign: TextAlign.center),
            AppDimens.gap16,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(LocaleKeys.common_retry.tr),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder trạng thái rỗng toàn màn hình.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 46, color: AppColors.textMuted),
            ),
            AppDimens.gap16,
            AppText.heading(title, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              AppDimens.gap8,
              AppText.body(subtitle!, textAlign: TextAlign.center),
            ],
            if (action != null) ...[AppDimens.gap16, action!],
          ],
        ),
      ),
    );
  }
}
