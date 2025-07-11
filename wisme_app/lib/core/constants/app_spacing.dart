import 'package:flutter/material.dart';

/// Wisme Spacing System - Consistent spacing based on 8px grid
/// Ensures visual harmony and rhythm throughout the app
class WismeSpacing {
  WismeSpacing._();

  // ===== BASE SPACING UNIT =====
  /// Base unit: 8px - All spacing derives from this
  static const double _base = 8.0;

  // ===== SPACING SCALE =====
  /// Micro spacing - 2px (for fine adjustments)
  static const double micro = _base * 0.25; // 2px

  /// Tiny spacing - 4px (for very close elements)
  static const double tiny = _base * 0.5; // 4px

  /// Extra small spacing - 8px (base unit)
  static const double xs = _base; // 8px

  /// Small spacing - 12px (common for padding)
  static const double sm = _base * 1.5; // 12px

  /// Medium spacing - 16px (standard element spacing)
  static const double md = _base * 2; // 16px

  /// Large spacing - 24px (section spacing)
  static const double lg = _base * 3; // 24px

  /// Extra large spacing - 32px (major section breaks)
  static const double xl = _base * 4; // 32px

  /// 2X large spacing - 48px (page-level spacing)
  static const double xxl = _base * 6; // 48px

  /// 3X large spacing - 64px (major visual breaks)
  static const double xxxl = _base * 8; // 64px

  // ===== SPECIALIZED SPACING =====
  /// Page padding - Standard padding for main content areas
  static const double pagePadding = lg; // 24px

  /// Card padding - Interior padding for cards and containers
  static const double cardPadding = md; // 16px

  /// Section spacing - Between major page sections
  static const double sectionSpacing = xl; // 32px

  /// Component spacing - Between related UI components
  static const double componentSpacing = md; // 16px

  /// List item spacing - Between list items
  static const double listItemSpacing = sm; // 12px

  /// Button padding - Interior button padding
  static const double buttonPadding = md; // 16px

  /// Input field padding - Interior input padding
  static const double inputPadding = md; // 16px

  // ===== LAYOUT SPECIFIC SPACING =====
  /// Safe area padding - Additional padding for safe areas
  static const double safeAreaPadding = md; // 16px

  /// Bottom navigation height
  static const double bottomNavHeight = 80.0;

  /// App bar height
  static const double appBarHeight = 56.0;

  /// Tab bar height
  static const double tabBarHeight = 48.0;

  // ===== ADAPTIVE SPACING METHODS =====
  /// Get responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 360) {
      // Small phones
      return const EdgeInsets.all(sm);
    } else if (screenWidth > 768) {
      // Tablets
      return const EdgeInsets.all(xl);
    } else {
      // Standard phones
      return const EdgeInsets.all(lg);
    }
  }

  /// Get responsive horizontal padding
  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 360) {
      return const EdgeInsets.symmetric(horizontal: sm);
    } else if (screenWidth > 768) {
      return const EdgeInsets.symmetric(horizontal: xl);
    } else {
      return const EdgeInsets.symmetric(horizontal: lg);
    }
  }

  // ===== COMMON EDGE INSETS =====
  /// Zero padding
  static const EdgeInsets zero = EdgeInsets.zero;

  /// All sides micro
  static const EdgeInsets allMicro = EdgeInsets.all(micro);

  /// All sides tiny
  static const EdgeInsets allTiny = EdgeInsets.all(tiny);

  /// All sides extra small
  static const EdgeInsets allXs = EdgeInsets.all(xs);

  /// All sides small
  static const EdgeInsets allSm = EdgeInsets.all(sm);

  /// All sides medium
  static const EdgeInsets allMd = EdgeInsets.all(md);

  /// All sides large
  static const EdgeInsets allLg = EdgeInsets.all(lg);

  /// All sides extra large
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// All sides 2X large
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  // ===== HORIZONTAL PADDING =====
  /// Horizontal micro
  static const EdgeInsets horizontalMicro = EdgeInsets.symmetric(horizontal: micro);

  /// Horizontal tiny
  static const EdgeInsets horizontalTiny = EdgeInsets.symmetric(horizontal: tiny);

  /// Horizontal extra small
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);

  /// Horizontal small
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);

  /// Horizontal medium
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal large
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Horizontal extra large
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // ===== VERTICAL PADDING =====
  /// Vertical micro
  static const EdgeInsets verticalMicro = EdgeInsets.symmetric(vertical: micro);

  /// Vertical tiny
  static const EdgeInsets verticalTiny = EdgeInsets.symmetric(vertical: tiny);

  /// Vertical extra small
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);

  /// Vertical small
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);

  /// Vertical medium
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Vertical large
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);

  /// Vertical extra large
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  // ===== SPECIFIC PADDING COMBINATIONS =====
  /// Page content padding (horizontal large, vertical medium)
  static const EdgeInsets pageContent = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Card content padding
  static const EdgeInsets cardContent = EdgeInsets.all(cardPadding);

  /// Button content padding
  static const EdgeInsets buttonContent = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );

  /// Input field content padding
  static const EdgeInsets inputContent = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// List item padding
  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );

  /// Modal padding
  static const EdgeInsets modal = EdgeInsets.all(lg);

  /// Bottom sheet padding
  static const EdgeInsets bottomSheet = EdgeInsets.fromLTRB(lg, md, lg, xl);

  // ===== BORDER RADIUS =====
  /// No radius
  static const Radius radiusNone = Radius.zero;

  /// Small radius - 4px
  static const Radius radiusSm = Radius.circular(4);

  /// Medium radius - 8px (base)
  static const Radius radiusMd = Radius.circular(8);

  /// Large radius - 12px
  static const Radius radiusLg = Radius.circular(12);

  /// Extra large radius - 16px
  static const Radius radiusXl = Radius.circular(16);

  /// 2X large radius - 24px
  static const Radius radiusXxl = Radius.circular(24);

  /// Circular radius - 9999px (perfect circle)
  static const Radius radiusCircular = Radius.circular(9999);

  // ===== BORDER RADIUS COMBINATIONS =====
  /// Small border radius
  static const BorderRadius borderRadiusSm = BorderRadius.all(radiusSm);

  /// Medium border radius
  static const BorderRadius borderRadiusMd = BorderRadius.all(radiusMd);

  /// Large border radius
  static const BorderRadius borderRadiusLg = BorderRadius.all(radiusLg);

  /// Extra large border radius
  static const BorderRadius borderRadiusXl = BorderRadius.all(radiusXl);

  /// 2X large border radius
  static const BorderRadius borderRadiusXxl = BorderRadius.all(radiusXxl);

  /// Circular border radius
  static const BorderRadius borderRadiusCircular = BorderRadius.all(radiusCircular);

  /// Top-only border radius (for cards, modals)
  static const BorderRadius borderRadiusTopMd = BorderRadius.only(
    topLeft: radiusMd,
    topRight: radiusMd,
  );

  static const BorderRadius borderRadiusTopLg = BorderRadius.only(
    topLeft: radiusLg,
    topRight: radiusLg,
  );

  static const BorderRadius borderRadiusTopXl = BorderRadius.only(
    topLeft: radiusXl,
    topRight: radiusXl,
  );

  // ===== GAP SPACING (for Flex layouts) =====
  /// Micro gap
  static const Widget gapMicro = SizedBox(width: micro, height: micro);

  /// Tiny gap
  static const Widget gapTiny = SizedBox(width: tiny, height: tiny);

  /// Extra small gap
  static const Widget gapXs = SizedBox(width: xs, height: xs);

  /// Small gap
  static const Widget gapSm = SizedBox(width: sm, height: sm);

  /// Medium gap
  static const Widget gapMd = SizedBox(width: md, height: md);

  /// Large gap
  static const Widget gapLg = SizedBox(width: lg, height: lg);

  /// Extra large gap
  static const Widget gapXl = SizedBox(width: xl, height: xl);

  /// 2X large gap
  static const Widget gapXxl = SizedBox(width: xxl, height: xxl);

  // ===== HORIZONTAL GAPS =====
  /// Horizontal micro gap
  static const Widget hGapMicro = SizedBox(width: micro);

  /// Horizontal tiny gap
  static const Widget hGapTiny = SizedBox(width: tiny);

  /// Horizontal extra small gap
  static const Widget hGapXs = SizedBox(width: xs);

  /// Horizontal small gap
  static const Widget hGapSm = SizedBox(width: sm);

  /// Horizontal medium gap
  static const Widget hGapMd = SizedBox(width: md);

  /// Horizontal large gap
  static const Widget hGapLg = SizedBox(width: lg);

  /// Horizontal extra large gap
  static const Widget hGapXl = SizedBox(width: xl);

  // ===== VERTICAL GAPS =====
  /// Vertical micro gap
  static const Widget vGapMicro = SizedBox(height: micro);

  /// Vertical tiny gap
  static const Widget vGapTiny = SizedBox(height: tiny);

  /// Vertical extra small gap
  static const Widget vGapXs = SizedBox(height: xs);

  /// Vertical small gap
  static const Widget vGapSm = SizedBox(height: sm);

  /// Vertical medium gap
  static const Widget vGapMd = SizedBox(height: md);

  /// Vertical large gap
  static const Widget vGapLg = SizedBox(height: lg);

  /// Vertical extra large gap
  static const Widget vGapXl = SizedBox(height: xl);

  /// Vertical 2X large gap
  static const Widget vGapXxl = SizedBox(height: xxl);

  // ===== LEARNING-SPECIFIC SPACING =====
  /// Episode card spacing
  static const EdgeInsets episodeCard = EdgeInsets.all(md);

  /// Coach card spacing
  static const EdgeInsets coachCard = EdgeInsets.all(lg);

  /// Progress card spacing
  static const EdgeInsets progressCard = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Journey step spacing
  static const EdgeInsets journeyStep = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  /// Audio player controls spacing
  static const EdgeInsets audioControls = EdgeInsets.all(sm);

  // ===== HELPER METHODS =====
  /// Create custom padding from individual values
  static EdgeInsets custom({
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return EdgeInsets.fromLTRB(
      left ?? 0,
      top ?? 0,
      right ?? 0,
      bottom ?? 0,
    );
  }

  /// Create symmetric padding
  static EdgeInsets symmetric({
    double? horizontal,
    double? vertical,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
      vertical: vertical ?? 0,
    );
  }

  /// Create custom gap widget
  static Widget gap(double size) => SizedBox(width: size, height: size);

  /// Create horizontal gap widget
  static Widget hGap(double width) => SizedBox(width: width);

  /// Create vertical gap widget
  static Widget vGap(double height) => SizedBox(height: height);
}
