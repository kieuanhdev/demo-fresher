import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

/// Nguồn chân lý duy nhất cho việc theming của app.
abstract class AppTheme {
  static ThemeData get light => _buildTheme(AppColors.light, Brightness.light);
  
  static ThemeData get dark => _buildTheme(AppColors.dark, Brightness.dark);

  static ThemeData _buildTheme(AppColors colors, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.primaryColor,
      primary: colors.primaryColor,
      secondary: colors.secondaryColor,
      surface: colors.surfaceColor,
      error: colors.dangerColor,
      brightness: brightness,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.backgroundColor,
      fontFamily: 'Roboto',
      splashFactory: InkSparkle.splashFactory,
      extensions: [colors],
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: colors.textPrimaryColor,
        displayColor: colors.textPrimaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceColor,
        foregroundColor: colors.textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        shadowColor: colors.borderColor,
        centerTitle: false,
        systemOverlayStyle: brightness == Brightness.light 
            ? SystemUiOverlayStyle.dark 
            : SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: colors.textPrimaryColor,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: colors.textPrimaryColor),
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: BorderSide(color: colors.borderColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceMutedColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: TextStyle(color: colors.textMutedColor),
        labelStyle: TextStyle(color: colors.textSecondaryColor),
        floatingLabelStyle: TextStyle(color: colors.primaryColor),
        prefixIconColor: colors.textMutedColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(color: colors.primaryColor, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(color: colors.dangerColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(color: colors.dangerColor, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryColor,
          side: BorderSide(color: colors.primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colors.primaryColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      dividerTheme: DividerThemeData(
        color: colors.borderColor,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
      ),
    );
  }
}
