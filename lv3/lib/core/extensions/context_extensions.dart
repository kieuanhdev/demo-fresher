import 'package:flutter/material.dart';

/// Các shortcut trên [BuildContext] — rút gọn boilerplate `Theme.of(context)` /
/// `MediaQuery.of` thành `context.theme` / `context.width`.
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// Breakpoint phân biệt điện thoại và tablet.
  bool get isTablet => width >= 600;

  void hideKeyboard() => FocusScope.of(this).unfocus();
}
