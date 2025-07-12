import 'package:flutter/material.dart';

/// Wisme Responsive Design System
/// Provides adaptive layouts and responsive utilities for all screen sizes
/// Ensures perfect user experience across mobile, tablet, and desktop
class WismeResponsive {
  WismeResponsive._();

  // ===== BREAKPOINTS =====
  static const double mobileSmall = 320;
  static const double mobile = 375;
  static const double mobileLarge = 414;
  static const double tablet = 768;
  static const double tabletLarge = 1024;
  static const double desktop = 1200;
  static const double desktopLarge = 1440;
  static const double desktopXL = 1920;

  // ===== DEVICE TYPE DETECTION =====
  static bool isMobileSmall(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tablet;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet && width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  // ===== SCREEN SIZE UTILITIES =====
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // ===== RESPONSIVE VALUES =====
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  // ===== RESPONSIVE PADDING =====
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: value(
        context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
      vertical: value(
        context,
        mobile: 16.0,
        tablet: 20.0,
        desktop: 24.0,
      ),
    );
  }

  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: value(
        context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
    );
  }

  static EdgeInsets responsiveContentPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: value(
        context,
        mobile: 20.0,
        tablet: 32.0,
        desktop: 48.0,
      ),
      vertical: value(
        context,
        mobile: 24.0,
        tablet: 32.0,
        desktop: 40.0,
      ),
    );
  }

  // ===== RESPONSIVE SPACING =====
  static double responsiveSpacing(BuildContext context) {
    return value(
      context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );
  }

  static double responsiveVerticalSpacing(BuildContext context) {
    return value(
      context,
      mobile: 20.0,
      tablet: 28.0,
      desktop: 36.0,
    );
  }

  // ===== RESPONSIVE FONT SIZES =====
  static double responsiveFontSize(
    BuildContext context, {
    required double baseFontSize,
  }) {
    final scaleFactor = value(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
    return baseFontSize * scaleFactor;
  }

  // ===== RESPONSIVE GRID =====
  static int responsiveGridColumns(BuildContext context) {
    return value(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  static double responsiveGridSpacing(BuildContext context) {
    return value(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  // ===== RESPONSIVE LAYOUT CONSTRAINTS =====
  static BoxConstraints responsiveConstraints(BuildContext context) {
    return BoxConstraints(
      maxWidth: value(
        context,
        mobile: double.infinity,
        tablet: 600.0,
        desktop: 800.0,
      ),
    );
  }

  static double responsiveMaxWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: 600.0,
      desktop: 1200.0,
    );
  }

  // ===== RESPONSIVE BUTTON SIZES =====
  static Size responsiveButtonSize(BuildContext context) {
    return Size(
      value(
        context,
        mobile: double.infinity,
        tablet: 200.0,
        desktop: 240.0,
      ),
      value(
        context,
        mobile: 48.0,
        tablet: 52.0,
        desktop: 56.0,
      ),
    );
  }

  static EdgeInsets responsiveButtonPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: value(
        context,
        mobile: 24.0,
        tablet: 32.0,
        desktop: 40.0,
      ),
      vertical: value(
        context,
        mobile: 12.0,
        tablet: 16.0,
        desktop: 20.0,
      ),
    );
  }

  // ===== RESPONSIVE NAVIGATION =====
  static bool shouldUseDrawer(BuildContext context) {
    return isMobile(context);
  }

  static bool shouldUseNavigationRail(BuildContext context) {
    return isTablet(context);
  }

  static bool shouldUseNavigationBar(BuildContext context) {
    return isDesktop(context);
  }

  // ===== RESPONSIVE MODAL SIZING =====
  static Size responsiveModalSize(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    if (isMobile(context)) {
      return Size(
        screenSize.width * 0.9,
        screenSize.height * 0.8,
      );
    } else if (isTablet(context)) {
      return Size(
        screenSize.width * 0.7,
        screenSize.height * 0.7,
      );
    } else {
      return Size(
        screenSize.width * 0.5,
        screenSize.height * 0.6,
      );
    }
  }

  // ===== RESPONSIVE SAFE AREA =====
  static EdgeInsets responsiveSafeArea(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom + (isMobile(context) ? 16.0 : 0.0),
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }

  // ===== RESPONSIVE IMAGE SIZING =====
  static double responsiveImageSize(BuildContext context) {
    return value(
      context,
      mobile: 120.0,
      tablet: 160.0,
      desktop: 200.0,
    );
  }

  static double responsiveIconSize(BuildContext context) {
    return value(
      context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  // ===== RESPONSIVE CARD SIZING =====
  static double responsiveCardHeight(BuildContext context) {
    return value(
      context,
      mobile: 200.0,
      tablet: 240.0,
      desktop: 280.0,
    );
  }

  static EdgeInsets responsiveCardPadding(BuildContext context) {
    return EdgeInsets.all(
      value(
        context,
        mobile: 16.0,
        tablet: 20.0,
        desktop: 24.0,
      ),
    );
  }

  // ===== RESPONSIVE ANIMATIONS =====
  static Duration responsiveAnimationDuration(BuildContext context) {
    return Duration(
      milliseconds: value(
        context,
        mobile: 300,
        tablet: 250,
        desktop: 200,
      ),
    );
  }

  // ===== RESPONSIVE LIST ITEM HEIGHT =====
  static double responsiveListItemHeight(BuildContext context) {
    return value(
      context,
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
    );
  }

  // ===== RESPONSIVE APP BAR HEIGHT =====
  static double responsiveAppBarHeight(BuildContext context) {
    return value(
      context,
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
    );
  }

  // ===== RESPONSIVE BORDER RADIUS =====
  static double responsiveBorderRadius(BuildContext context) {
    return value(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  // ===== ORIENTATION HELPERS =====
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // ===== RESPONSIVE WRAP =====
  static Widget responsiveWrap({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? responsiveMaxWidth(context),
        ),
        child: child,
      ),
    );
  }

  // ===== RESPONSIVE GRID VIEW =====
  static Widget responsiveGridView({
    required BuildContext context,
    required List<Widget> children,
    int? crossAxisCount,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    double? childAspectRatio,
  }) {
    return GridView.count(
      crossAxisCount: crossAxisCount ?? responsiveGridColumns(context),
      mainAxisSpacing: mainAxisSpacing ?? responsiveGridSpacing(context),
      crossAxisSpacing: crossAxisSpacing ?? responsiveGridSpacing(context),
      childAspectRatio: childAspectRatio ?? 1.0,
      children: children,
    );
  }
}
