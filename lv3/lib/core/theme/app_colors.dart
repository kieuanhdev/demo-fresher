import 'package:flutter/material.dart';

/// Bảng màu tập trung — theo hướng sạch / tối giản.
abstract class AppColors {
  // Brand (dùng hạn chế: button, trạng thái active, accent)
  static const primary = Color(0xFF4F46E5); // indigo-600
  static const primaryDark = Color(0xFF4338CA);
  static const secondary = Color(0xFF7C3AED);
  static const accent = Color(0xFF06B6D4);

  // Status
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);

  // Surface — sáng, thoáng
  static const background = Color(0xFFF7F8FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1F2F6);

  // Text
  static const textPrimary = Color(0xFF16181F);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted = Color(0xFFA1A6B3);

  // Border mảnh (kiểu tối giản dựa vào cái này, không dùng shadow)
  static const border = Color(0xFFECEDF2);

  // Helper tint cho nền icon dịu nhẹ
  static Color tint(Color c) => c.withValues(alpha: 0.10);

  // Giữ lại cho vài surface accent (logo badge, v.v.)
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  /// Elevation rất nhẹ — chỉ dùng ở nơi thực sự cần độ nổi.
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF1B1F3B).withValues(alpha: 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
