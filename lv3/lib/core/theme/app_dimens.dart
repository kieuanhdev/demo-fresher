import 'package:flutter/widgets.dart';

/// Các token spacing, radius và font-size. Tránh hardcode các số magic trong UI.
abstract class AppDimens {
  // Spacing
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;

  // Radius
  static const double radiusSm = 10;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;

  // Font sizes
  static const double fontCaption = 12.5;
  static const double fontBody = 14;
  static const double fontTitle = 16;
  static const double fontHeading = 20;
  static const double fontDisplay = 26;

  // Common gaps
  static const SizedBox gap4 = SizedBox(height: space4, width: space4);
  static const SizedBox gap8 = SizedBox(height: space8, width: space8);
  static const SizedBox gap12 = SizedBox(height: space12, width: space12);
  static const SizedBox gap16 = SizedBox(height: space16, width: space16);
  static const SizedBox gap24 = SizedBox(height: space24, width: space24);

  static const EdgeInsets pagePadding = EdgeInsets.all(space20);
}
