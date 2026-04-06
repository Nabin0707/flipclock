# Flutter ScreenUtil - Responsive Design Implementation Guide

## Overview

This project uses `flutter_screenutil` package for responsive UI across different screen sizes. This guide explains how to use responsive values throughout the application.

## Setup

### 1. Package Installation

```yaml
# pubspec.yaml
dependencies:
  flutter_screenutil: ^5.9.0
```

### 2. Initialization

The app is initialized with ScreenUtil in `main.dart`:

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

@override
Widget build(BuildContext context, WidgetRef ref) {
  return ScreenUtilInit(
    designSize: const Size(375, 812), // iPhone 11 Pro as baseline
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {
      return MaterialApp.router(
        // ... app configuration
      );
    },
  );
}
```

## Responsive Extensions

### Width & Height

- `.w` - Responsive width
- `.h` - Responsive height

```dart
// Before
Container(width: 100, height: 50)

// After
Container(width: 100.w, height: 50.h)
```

### Font Size

- `.sp` - Scalable pixel for text

```dart
// Before
TextStyle(fontSize: 16)

// After
TextStyle(fontSize: 16.sp)
```

### Border Radius

- `.r` - Responsive radius

```dart
// Before
BorderRadius.circular(8)

// After
BorderRadius.circular(8.r)
```

## Common Patterns

### 1. EdgeInsets Padding/Margin

```dart
// All sides
EdgeInsets.all(16)      →  EdgeInsets.all(16.w)

// Symmetric
EdgeInsets.symmetric(
  horizontal: 24,       →  horizontal: 24.w,
  vertical: 12,         →  vertical: 12.h,
)

// Only specific sides
EdgeInsets.only(
  left: 16,            →  left: 16.w,
  top: 8,              →  top: 8.h,
  right: 16,           →  right: 16.w,
  bottom: 8,           →  bottom: 8.h,
)
```

### 2. SizedBox

```dart
// Height
SizedBox(height: 12)    →  SizedBox(height: 12.h)

// Width
SizedBox(width: 8)      →  SizedBox(width: 8.w)

// Both
SizedBox(
  width: 100,           →  width: 100.w,
  height: 50,           →  height: 50.h,
)
```

### 3. Container Sizing

```dart
Container(
  width: 200,           →  width: 200.w,
  height: 100,          →  height: 100.h,
  padding: EdgeInsets.all(16),  →  padding: EdgeInsets.all(16.w),
)
```

### 4. Icon Sizes

```dart
Icon(Icons.home, size: 24)  →  Icon(Icons.home, size: 24.sp)
```

### 5. Text Styles

```dart
TextStyle(
  fontSize: 16,         →  fontSize: 16.sp,
  letterSpacing: 0.5,   →  letterSpacing: 0.5.w,
  height: 1.5,          // Line height ratio - no conversion needed
)
```

### 6. Border Radius

```dart
BorderRadius.circular(8)        →  BorderRadius.circular(8.r)
Radius.circular(4)              →  Radius.circular(4.r)
RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(12),  →  borderRadius: BorderRadius.circular(12.r),
)
```

### 7. Border Width

```dart
BorderSide(width: 1.5)  →  BorderSide(width: 1.5.w)
```

### 8. Button Sizing

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: Size(120, 48),  →  minimumSize: Size(120.w, 48.h),
    padding: EdgeInsets.symmetric(  →  padding: EdgeInsets.symmetric(
      horizontal: 24,                    horizontal: 24.w,
      vertical: 12,                      vertical: 12.h,
    ),
  ),
)
```

## Helper Utilities

### ResponsiveSpacing Class

Located in `lib/core/utils/responsive_utils.dart`:

```dart
class ResponsiveSpacing {
  // Standard spacing values
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;

  // Border radius
  static double get radiusXs => 2.r;
  static double get radiusSm => 4.r;
  static double get radiusMd => 8.r;
  static double get radiusLg => 12.r;
  static double get radiusXl => 16.r;
  static double get radiusXxl => 20.r;

  // Icon sizes
  static double get iconXs => 16.sp;
  static double get iconSm => 20.sp;
  static double get iconMd => 24.sp;
  static double get iconLg => 32.sp;
  static double get iconXl => 40.sp;
  static double get iconXxl => 48.sp;

  // Button heights
  static double get buttonHeightSm => 36.h;
  static double get buttonHeightMd => 44.h;
  static double get buttonHeightLg => 52.h;
  static double get buttonHeightXl => 60.h;
}
```

**Usage:**

```dart
// Instead of hardcoding
padding: EdgeInsets.all(16.w)

// Use the helper
padding: EdgeInsets.all(ResponsiveSpacing.lg)
```

### ResponsiveFontSizes Class

```dart
class ResponsiveFontSizes {
  static double get xs => 10.sp;
  static double get sm => 12.sp;
  static double get md => 14.sp;
  static double get base => 16.sp;
  static double get lg => 18.sp;
  static double get xl => 20.sp;
  static double get xxl => 24.sp;
  static double get xxxl => 28.sp;
  static double get huge => 32.sp;
  static double get massive => 40.sp;
}
```

**Usage:**

```dart
Text(
  'Hello',
  style: TextStyle(fontSize: ResponsiveFontSizes.lg),
)
```

## Screen Size Queries

ScreenUtil also provides direct access to screen dimensions:

```dart
ScreenUtil().screenWidth    // Screen width in px
ScreenUtil().screenHeight   // Screen height in px
ScreenUtil().statusBarHeight // Status bar height
ScreenUtil().bottomBarHeight // Bottom bar height

1.sw  // 1% of screen width
1.sh  // 1% of screen height
```

## When NOT to Use Responsive Values

1. **Line height ratio** - Keep as regular double:

   ```dart
   TextStyle(height: 1.5)  // ✅ No conversion needed
   ```

2. **Opacity/Alpha values** - Keep as 0-1 range:

   ```dart
   color.withValues(alpha:0.5)  // ✅ No conversion needed
   ```

3. **Flex values** - Keep as integers:

   ```dart
   Expanded(flex: 2)  // ✅ No conversion needed
   ```

4. **Animation duration** - Keep as milliseconds:
   ```dart
   Duration(milliseconds: 300)  // ✅ No conversion needed
   ```

## Migration Checklist

When adding responsiveness to a widget:

- [ ] Add `import 'package:flutter_screenutil/flutter_screenutil.dart';`
- [ ] Convert all `EdgeInsets` values with `.w` and `.h`
- [ ] Convert all `SizedBox` dimensions with `.w` and `.h`
- [ ] Convert all `Container` widths/heights with `.w` and `.h`
- [ ] Convert all `fontSize` values with `.sp`
- [ ] Convert all icon sizes with `.sp`
- [ ] Convert all `BorderRadius.circular()` with `.r`
- [ ] Convert all `BorderSide` widths with `.w`
- [ ] Convert button minimum sizes with `.w` and `.h`
- [ ] Test on different screen sizes

## Component Status

### ✅ Fully Responsive Components

- **Buttons**

  - [x] PrimaryButton
  - [x] SecondaryButton
  - [x] OutlineButton
  - [x] AppTextButton
  - [x] CustomIconButton
  - [x] CircularIconButton

- **Utils**
  - [x] ResponsiveSpacing helper class
  - [x] ResponsiveFontSizes helper class

### ⏳ Partially Responsive Components

- **Inputs**
  - [x] AppTextField (import added, needs value conversion)
  - [ ] PasswordTextField (needs conversion)
  - [ ] ConfirmPasswordTextField (needs conversion)
  - [ ] EmailTextField (needs conversion)
  - [ ] PhoneTextField (needs conversion)
  - [ ] SearchTextField (needs conversion)
  - [ ] MultilineTextField (needs conversion)

### 📋 TODO: Needs Full Conversion

- **Cards**

  - [ ] ProductCard
  - [ ] HorizontalProductCard
  - [ ] InfoCard
  - [ ] CustomCard
  - [ ] HeaderCard
  - [ ] ExpandableCard

- **Common Widgets**

  - [ ] AppAvatar
  - [ ] AppBadge
  - [ ] AppChip
  - [ ] AppDivider
  - [ ] AppRating
  - [ ] AppTag
  - [ ] AppTimeline
  - [ ] EmptyState
  - [ ] ErrorWidget
  - [ ] LoadingIndicator

- **Dialogs & Modals**

  - [ ] AppDialogs
  - [ ] AppSnackbars
  - [ ] ModalBottomSheet

- **Pagination**

  - [ ] PaginationInfo
  - [ ] PageNumberButtons
  - [ ] LoadMoreButton

- **AppBars**

  - [ ] CustomAppBar
  - [ ] ThemeAppBar

- **Templates**

  - [ ] ListPageTemplate
  - [ ] DetailPageTemplate
  - [ ] FormPageTemplate
  - [ ] ProfilePageTemplate
  - [ ] SettingsPageTemplate

- **Screens**
  - [ ] LoginScreen
  - [ ] RegisterScreen
  - [ ] SplashScreen
  - [ ] HomeScreen
  - [ ] DemoPage
  - [ ] TemplatesDemo

## Testing Responsive Design

### Test on Multiple Sizes

```dart
// Test different design sizes
ScreenUtilInit(
  designSize: const Size(375, 812),  // iPhone 11 Pro
  // designSize: const Size(414, 896),  // iPhone 11 Pro Max
  // designSize: const Size(360, 640),  // Android average
  // designSize: const Size(768, 1024), // iPad
)
```

### Use Device Preview Package

Add `device_preview` for testing:

```yaml
dev_dependencies:
  device_preview: ^1.1.0
```

```dart
void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: MyApp()),
    ),
  );
}
```

## Best Practices

1. **Consistent Design Size**: Stick to one design size (e.g., 375x812) across the project
2. **Use Helper Classes**: Prefer `ResponsiveSpacing.lg` over raw values like `16.w`
3. **Semantic Values**: Use meaningful constants instead of magic numbers
4. **Test Early**: Check responsiveness on different sizes during development
5. **Minimum Tap Targets**: Ensure interactive elements are at least 44x44 logical pixels
6. **Text Scaling**: Always use `.sp` for font sizes to support accessibility
7. **Aspect Ratios**: For images and containers, consider using `AspectRatio` widget
8. **Safe Areas**: Always consider `SafeArea` or `MediaQuery.of(context).padding`

## Common Issues & Solutions

### Issue 1: Text Too Large on Small Screens

```dart
// Use minTextAdapt
ScreenUtilInit(
  minTextAdapt: true,  // ✅ Ensures minimum text size
)
```

### Issue 2: Inconsistent Spacing

```dart
// ❌ Bad: Mixed approaches
padding: EdgeInsets.all(16)
margin: EdgeInsets.all(16.w)

// ✅ Good: Consistent approach
padding: EdgeInsets.all(16.w)
margin: EdgeInsets.all(16.w)
```

### Issue 3: Over-responsive Components

```dart
// For some components, you might want fixed sizes
// Use regular values when appropriate
Icon(Icons.check, size: 16)  // Fixed size checkbox icon
```

## Resources

- [flutter_screenutil package](https://pub.dev/packages/flutter_screenutil)
- [Flutter Responsive Design Guide](https://docs.flutter.dev/ui/layout/responsive)
- [Material Design Layout](https://material.io/design/layout)

---

## Migration Progress

**Last Updated:** [Date]

- ✅ **Phase 1: Setup** - ScreenUtil initialized in main.dart
- ✅ **Phase 2: Buttons** - All button widgets updated
- ⏳ **Phase 3: Inputs** - In progress
- 📋 **Phase 4: Cards** - Pending
- 📋 **Phase 5: Common Widgets** - Pending
- 📋 **Phase 6: Screens** - Pending
- 📋 **Phase 7: Templates** - Pending

**Estimated Completion:** [Estimate based on remaining components]
