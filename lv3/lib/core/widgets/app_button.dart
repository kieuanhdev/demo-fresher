import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'app_text.dart';

/// Nút hành động chính (primary action button).
///
/// Tự quản lý trạng thái busy của chính nó (chống double-tap) VÀ cả cờ [loading]
/// bên ngoài từ controller — chỉ cần một trong hai cũng đủ để vô hiệu hóa nút và
/// hiển thị spinner. Tương ứng với `BaseButton` / `HandleButton` trong guide.
class AppButton extends StatefulWidget {
  final String label;
  final FutureOr<void> Function()? onPressed;
  final bool loading;
  final IconData? icon;
  final bool expand;
  final Color? color;
  final bool outlined;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.expand = true,
    this.color,
    this.outlined = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _busy = false;

  bool get _isLoading => _busy || widget.loading;

  Future<void> _handle() async {
    if (_isLoading || widget.onPressed == null) return;
    setState(() => _busy = true);
    try {
      await Future.sync(widget.onPressed!);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final child = _isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : _content(Colors.white);

    final button = widget.outlined
        ? OutlinedButton(
            onPressed: disabled ? null : _handle,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : _content(widget.color ?? AppColors.primary),
          )
        : FilledButton(
            onPressed: disabled ? null : _handle,
            style: widget.color != null
                ? FilledButton.styleFrom(backgroundColor: widget.color)
                : null,
            child: child,
          );

    return SizedBox(
      width: widget.expand ? double.infinity : null,
      child: button,
    );
  }

  Widget _content(Color fg) {
    if (widget.icon == null) {
      return AppText.title(widget.label, color: fg);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: 20, color: fg),
        AppDimens.gap8,
        AppText.title(widget.label, color: fg),
      ],
    );
  }
}
