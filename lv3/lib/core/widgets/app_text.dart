import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

/// Widget text chuẩn hóa. Dùng các factory có tên thay vì [Text] trực tiếp
/// để typography luôn nhất quán (tương ứng với `AppText` trong guide).
class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int? maxLines;
  final TextAlign textAlign;

  const AppText._(
    this.text, {
    required this.style,
    this.maxLines,
    this.textAlign = TextAlign.start,
  });

  /// Tiêu đề lớn của màn hình/section.
  factory AppText.display(
    String text, {
    Color? color,
    double size = AppDimens.fontDisplay,
    int? maxLines = 2,
    TextAlign textAlign = TextAlign.start,
  }) =>
      AppText._(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontSize: size,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      );

  /// Tiêu đề của section.
  factory AppText.heading(
    String text, {
    Color? color,
    double size = AppDimens.fontHeading,
    int? maxLines = 2,
    TextAlign textAlign = TextAlign.start,
  }) =>
      AppText._(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontSize: size,
          fontWeight: FontWeight.w700,
        ),
      );

  /// Tiêu đề hơi đậm (tiêu đề item trong list, v.v.).
  factory AppText.title(
    String text, {
    Color? color,
    double size = AppDimens.fontTitle,
    int? maxLines = 1,
    TextAlign textAlign = TextAlign.start,
  }) =>
      AppText._(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontSize: size,
          fontWeight: FontWeight.w700,
        ),
      );

  /// Nội dung body thông thường.
  factory AppText.body(
    String text, {
    Color? color,
    double size = AppDimens.fontBody,
    FontWeight fontWeight = FontWeight.w400,
    int? maxLines = 5,
    TextAlign textAlign = TextAlign.start,
  }) =>
      AppText._(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          color: color ?? AppColors.textSecondary,
          fontSize: size,
          fontWeight: fontWeight,
        ),
      );

  /// Caption nhỏ, màu mờ.
  factory AppText.caption(
    String text, {
    Color? color,
    double size = AppDimens.fontCaption,
    int? maxLines = 2,
    TextAlign textAlign = TextAlign.start,
  }) =>
      AppText._(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        style: TextStyle(
          color: color ?? AppColors.textMuted,
          fontSize: size,
          fontWeight: FontWeight.w500,
        ),
      );

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
      );
}
