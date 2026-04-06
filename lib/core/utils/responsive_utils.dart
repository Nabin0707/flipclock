import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

/// Responsive spacing constants using ScreenUtil
/// Use these throughout the app for consistent responsive spacing
/// These methods automatically adapt to screen orientation
class ResponsiveSpacing {
  // Padding values - uses setWidth for consistent spacing regardless of orientation
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;

  // Vertical spacing - uses setHeight for vertical gaps
  static double get verticalXs => 4.h;
  static double get verticalSm => 8.h;
  static double get verticalMd => 12.h;
  static double get verticalLg => 16.h;
  static double get verticalXl => 20.h;
  static double get verticalXxl => 24.h;
  static double get verticalXxxl => 32.h;

  // Radius values - uses radius for proper circular adaptation
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 20.r;
  static double get radiusXxl => 24.r;

  // Icon sizes - uses .r for proportional scaling (NOT .sp for text scaling)
  // NOTE: .sp would make icons huge with text accessibility settings
  // .r maintains proper visual proportions across all screen sizes
  static double get iconXs => 16.r;
  static double get iconSm => 20.r;
  static double get iconMd => 24.r;
  static double get iconLg => 32.r;
  static double get iconXl => 40.r;
  static double get iconXxl => 48.r;

  // Button heights - uses screenHeight percentage for better adaptation
  static double get buttonHeightSm => 36.h;
  static double get buttonHeightMd => 44.h;
  static double get buttonHeightLg => 52.h;
  static double get buttonHeightXl => 60.h;

  // Input field padding - optimized for text input (smaller vertical padding)
  // Uses .r for proportional scaling that works in all orientations
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(
        horizontal: 16.r,
        vertical: 10.r, // Smaller vertical for more compact input fields
      );
  static EdgeInsets get inputPaddingCompact => EdgeInsets.symmetric(
        horizontal: 12.r,
        vertical: 8.r, // Even more compact for landscape/tablets
      );

  // Responsive padding helpers that adapt to orientation
  static EdgeInsets all(double value) => EdgeInsets.all(value.w);
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(
        left: left.w,
        top: top.h,
        right: right.w,
        bottom: bottom.h,
      );

  // Responsive sizing helpers
  static double width(double value) => value.w;
  static double height(double value) => value.h;
  static double size(double value) =>
      value.r; // Uses radius for square dimensions
  static double fontSize(double value) => value.sp;
}

/// Responsive font sizes using ScreenUtil
/// Use these for consistent responsive typography
/// Uses .sp which adapts to both screen size and text scaling settings
class ResponsiveFontSizes {
  static double get xs => 10.sp;
  static double get sm => 12.sp;
  static double get md => 14.sp;
  static double get lg => 16.sp;
  static double get xl => 18.sp;
  static double get xxl => 20.sp;
  static double get xxxl => 24.sp;
  static double get huge => 32.sp;
  static double get massive => 40.sp;
}

/// Extension methods for easier responsive sizing
extension ResponsiveExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => ScreenUtil().screenWidth;

  /// Get screen height
  double get screenHeight => ScreenUtil().screenHeight;

  /// Check if device is in landscape orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if device is in portrait orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Get responsive width (adapts to orientation)
  double responsiveWidth(double percentage) => screenWidth * percentage / 100;

  /// Get responsive height (adapts to orientation)
  double responsiveHeight(double percentage) => screenHeight * percentage / 100;

  /// Get minimum of width and height (useful for square elements)
  double get minDimension =>
      screenWidth < screenHeight ? screenWidth : screenHeight;

  /// Get maximum of width and height
  double get maxDimension =>
      screenWidth > screenHeight ? screenWidth : screenHeight;
}

/// Responsive breakpoints for different device sizes
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  /// Check if device is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  /// Get value based on device type
  static T valueForDevice<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}
