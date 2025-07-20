/// Wisme Design System - Spacing
/// Consistent spacing values across the Wisme app
library;

import 'package:flutter/material.dart';

/// Spacing system for Wisme app
class WismeSpacing {
  // Private constructor to prevent instantiation
  WismeSpacing._();

  // Base spacing unit (4px)
  static const double base = 4.0;

  // Spacing values
  static const double xs = base; // 4px
  static const double sm = base * 2; // 8px
  static const double md = base * 3; // 12px
  static const double lg = base * 4; // 16px
  static const double xl = base * 5; // 20px
  static const double xxl = base * 6; // 24px
  static const double xxxl = base * 8; // 32px

  // Common spacing values
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space28 = 28.0;
  static const double space32 = 32.0;
  static const double space36 = 36.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;

  // Edge insets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXXXL = EdgeInsets.all(xxxl);

  // Horizontal padding
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(horizontal: xxl);
  static const EdgeInsets horizontalXXXL = EdgeInsets.symmetric(horizontal: xxxl);

  // Vertical padding
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(vertical: xxl);
  static const EdgeInsets verticalXXXL = EdgeInsets.symmetric(vertical: xxxl);

  // Common edge insets
  static const EdgeInsets padding4 = EdgeInsets.all(space4);
  static const EdgeInsets padding8 = EdgeInsets.all(space8);
  static const EdgeInsets padding12 = EdgeInsets.all(space12);
  static const EdgeInsets padding16 = EdgeInsets.all(space16);
  static const EdgeInsets padding20 = EdgeInsets.all(space20);
  static const EdgeInsets padding24 = EdgeInsets.all(space24);
  static const EdgeInsets padding32 = EdgeInsets.all(space32);

  // SizedBox spacing
  static const SizedBox spaceXS = SizedBox(width: xs, height: xs);
  static const SizedBox spaceSM = SizedBox(width: sm, height: sm);
  static const SizedBox spaceMD = SizedBox(width: md, height: md);
  static const SizedBox spaceLG = SizedBox(width: lg, height: lg);
  static const SizedBox spaceXL = SizedBox(width: xl, height: xl);
  static const SizedBox spaceXXL = SizedBox(width: xxl, height: xxl);
  static const SizedBox spaceXXXL = SizedBox(width: xxxl, height: xxxl);

  // Horizontal spacing
  static const SizedBox horizontalSpaceXS = SizedBox(width: xs);
  static const SizedBox horizontalSpaceSM = SizedBox(width: sm);
  static const SizedBox horizontalSpaceMD = SizedBox(width: md);
  static const SizedBox horizontalSpaceLG = SizedBox(width: lg);
  static const SizedBox horizontalSpaceXL = SizedBox(width: xl);
  static const SizedBox horizontalSpaceXXL = SizedBox(width: xxl);
  static const SizedBox horizontalSpaceXXXL = SizedBox(width: xxxl);

  // Vertical spacing
  static const SizedBox verticalSpaceXS = SizedBox(height: xs);
  static const SizedBox verticalSpaceSM = SizedBox(height: sm);
  static const SizedBox verticalSpaceMD = SizedBox(height: md);
  static const SizedBox verticalSpaceLG = SizedBox(height: lg);
  static const SizedBox verticalSpaceXL = SizedBox(height: xl);
  static const SizedBox verticalSpaceXXL = SizedBox(height: xxl);
  static const SizedBox verticalSpaceXXXL = SizedBox(height: xxxl);

  // Utility methods
  static SizedBox height(double height) => SizedBox(height: height);
  static SizedBox width(double width) => SizedBox(width: width);
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  // Border radius values
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;

  // Border radius getters
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);

  // Component-specific padding
  static EdgeInsets get buttonContent => const EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  static EdgeInsets get inputContent => const EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  static EdgeInsets get listItem => const EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );

  // Additional spacing getters for theme compatibility
  static EdgeInsets get allXs => paddingXS;
  static EdgeInsets get allLg => paddingLG;
  static EdgeInsets get horizontalSm => horizontalSM;

  // Navigation specific values
  static const double bottomNavHeight = 60.0;

  // Horizontal gap utilities
  static SizedBox get hGapSm => const SizedBox(width: sm);
}
