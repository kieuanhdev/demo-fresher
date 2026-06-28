import 'package:flutter/material.dart';
import 'package:lv3/core/theme/theme_service.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primaryColor;
  final Color primaryDarkColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color dangerColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color surfaceMutedColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textMutedColor;
  final Color borderColor;

  const AppColors({
    required this.primaryColor,
    required this.primaryDarkColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.dangerColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.surfaceMutedColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.textMutedColor,
    required this.borderColor,
  });

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primaryColor,
    Color? primaryDarkColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? successColor,
    Color? warningColor,
    Color? dangerColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? surfaceMutedColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? textMutedColor,
    Color? borderColor,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      primaryDarkColor: primaryDarkColor ?? this.primaryDarkColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      dangerColor: dangerColor ?? this.dangerColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      surfaceMutedColor: surfaceMutedColor ?? this.surfaceMutedColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      textMutedColor: textMutedColor ?? this.textMutedColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      primaryDarkColor: Color.lerp(
        primaryDarkColor,
        other.primaryDarkColor,
        t,
      )!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      surfaceMutedColor: Color.lerp(
        surfaceMutedColor,
        other.surfaceMutedColor,
        t,
      )!,
      textPrimaryColor: Color.lerp(
        textPrimaryColor,
        other.textPrimaryColor,
        t,
      )!,
      textSecondaryColor: Color.lerp(
        textSecondaryColor,
        other.textSecondaryColor,
        t,
      )!,
      textMutedColor: Color.lerp(textMutedColor, other.textMutedColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }

  LinearGradient get brandGradientValue => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor],
  );

  // --- THIẾT LẬP LIGHT MODE ---
  static const AppColors light = AppColors(
    primaryColor: Color(0xFF4F46E5),
    primaryDarkColor: Color(0xFF4338CA),
    secondaryColor: Color(0xFF7C3AED),
    accentColor: Color(0xFF06B6D4),
    successColor: Color(0xFF16A34A),
    warningColor: Color(0xFFF59E0B),
    dangerColor: Color(0xFFEF4444),
    backgroundColor: Color(0xFFF7F8FA),
    surfaceColor: Color(0xFFFFFFFF),
    surfaceMutedColor: Color(0xFFF1F2F6),
    textPrimaryColor: Color(0xFF16181F),
    textSecondaryColor: Color(0xFF6B7280),
    textMutedColor: Color(0xFFA1A6B3),
    borderColor: Color(0xFFECEDF2),
  );

  // --- THIẾT LẬP DARK MODE ---
  static const AppColors dark = AppColors(
    primaryColor: Color(0xFF6366F1), // indigo-500 (sáng hơn chút cho Dark mode)
    primaryDarkColor: Color(0xFF4F46E5),
    secondaryColor: Color(0xFF8B5CF6), // violet-500
    accentColor: Color(0xFF22D3EE),
    successColor: Color(0xFF22C55E),
    warningColor: Color(0xFFF59E0B),
    dangerColor: Color(0xFFEF4444),
    backgroundColor: Color(0xFF0F172A), // slate-900
    surfaceColor: Color(0xFF1E293B), // slate-800
    surfaceMutedColor: Color(0xFF334155), // slate-700
    textPrimaryColor: Color(0xFFF8FAFC), // slate-50
    textSecondaryColor: Color(0xFF94A3B8), // slate-400
    textMutedColor: Color(0xFF64748B), // slate-500
    borderColor: Color(0xFF334155), // slate-700
  );

  // --- TRỢ THỦ LẤY THEME HIỆN TẠI (GETX) ---
  static AppColors get current {
    try {
      // ignore: prefer_const_constructors
      return ThemeService.isDarkMode.value ? dark : light;
    } catch (_) {
      return light;
    }
  }

  // --- TƯƠNG THÍCH NGƯỢC (STATIC GETTERS) ---
  static Color get primary => current.primaryColor;
  static Color get primaryDark => current.primaryDarkColor;
  static Color get secondary => current.secondaryColor;
  static Color get accent => current.accentColor;
  static Color get success => current.successColor;
  static Color get warning => current.warningColor;
  static Color get danger => current.dangerColor;
  static Color get background => current.backgroundColor;
  static Color get surface => current.surfaceColor;
  static Color get surfaceMuted => current.surfaceMutedColor;
  static Color get textPrimary => current.textPrimaryColor;
  static Color get textSecondary => current.textSecondaryColor;
  static Color get textMuted => current.textMutedColor;
  static Color get border => current.borderColor;

  static Color tint(Color c) => c.withValues(alpha: 0.10);

  static LinearGradient get brandGradient => current.brandGradientValue;

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: const Color(
        0xFF1B1F3B,
      ).withValues(alpha: current == dark ? 0.3 : 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
