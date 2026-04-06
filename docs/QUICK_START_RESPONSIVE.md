# Quick Start: Flutter ScreenUtil Usage

## Installation ✅ DONE

```yaml
dependencies:
  flutter_screenutil: ^5.9.0
```

## Initialization ✅ DONE

```dart
// lib/main.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

return ScreenUtilInit(
  designSize: const Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) => MaterialApp(...),
);
```

## Quick Reference Card

### Import

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

### Cheat Sheet

| Type                   | Before                     | After                        |
| ---------------------- | -------------------------- | ---------------------------- |
| **Width**              | `width: 100`               | `width: 100.w`               |
| **Height**             | `height: 50`               | `height: 50.h`               |
| **Font Size**          | `fontSize: 16`             | `fontSize: 16.sp`            |
| **Border Radius**      | `BorderRadius.circular(8)` | `BorderRadius.circular(8.r)` |
| **Padding All**        | `EdgeInsets.all(16)`       | `EdgeInsets.all(16.w)`       |
| **Padding Horizontal** | `horizontal: 24`           | `horizontal: 24.w`           |
| **Padding Vertical**   | `vertical: 12`             | `vertical: 12.h`             |
| **Icon Size**          | `size: 24`                 | `size: 24.sp`                |
| **Border Width**       | `width: 1.5`               | `width: 1.5.w`               |

## Helper Classes ✅ AVAILABLE

```dart
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// Spacing
ResponsiveSpacing.xs    // 4.w
ResponsiveSpacing.sm    // 8.w
ResponsiveSpacing.md    // 12.w
ResponsiveSpacing.lg    // 16.w
ResponsiveSpacing.xl    // 20.w
ResponsiveSpacing.xxl   // 24.w
ResponsiveSpacing.xxxl  // 32.w

// Radius
ResponsiveSpacing.radiusXs  // 2.r
ResponsiveSpacing.radiusSm  // 4.r
ResponsiveSpacing.radiusMd  // 8.r
ResponsiveSpacing.radiusLg  // 12.r
ResponsiveSpacing.radiusXl  // 16.r

// Icons
ResponsiveSpacing.iconXs   // 16.sp
ResponsiveSpacing.iconSm   // 20.sp
ResponsiveSpacing.iconMd   // 24.sp
ResponsiveSpacing.iconLg   // 32.sp
ResponsiveSpacing.iconXl   // 40.sp

// Font Sizes
ResponsiveFontSizes.xs       // 10.sp
ResponsiveFontSizes.sm       // 12.sp
ResponsiveFontSizes.md       // 14.sp
ResponsiveFontSizes.base     // 16.sp
ResponsiveFontSizes.lg       // 18.sp
ResponsiveFontSizes.xl       // 20.sp
ResponsiveFontSizes.xxl      // 24.sp
ResponsiveFontSizes.xxxl     // 28.sp
ResponsiveFontSizes.huge     // 32.sp
ResponsiveFontSizes.massive  // 40.sp
```

## Common Examples

### Button

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: Size(120.w, 48.h),
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
  ),
  child: Text(
    'Button',
    style: TextStyle(fontSize: 16.sp),
  ),
)
```

### Container

```dart
Container(
  width: 200.w,
  height: 100.h,
  padding: EdgeInsets.all(16.w),
  margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(width: 1.w),
  ),
  child: Text(
    'Content',
    style: TextStyle(fontSize: 14.sp),
  ),
)
```

### Card

```dart
Card(
  margin: EdgeInsets.all(ResponsiveSpacing.lg),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusLg),
  ),
  child: Padding(
    padding: EdgeInsets.all(ResponsiveSpacing.lg),
    child: Column(
      children: [
        Icon(Icons.info, size: ResponsiveSpacing.iconMd),
        SizedBox(height: ResponsiveSpacing.sm),
        Text(
          'Title',
          style: TextStyle(fontSize: ResponsiveFontSizes.lg),
        ),
      ],
    ),
  ),
)
```

### TextField

```dart
TextField(
  decoration: InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 12.h,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    prefixIcon: Icon(Icons.search, size: 20.sp),
  ),
  style: TextStyle(fontSize: 16.sp),
)
```

### List Item

```dart
ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  leading: Icon(Icons.person, size: 24.sp),
  title: Text(
    'Title',
    style: TextStyle(fontSize: 16.sp),
  ),
  subtitle: Text(
    'Subtitle',
    style: TextStyle(fontSize: 14.sp),
  ),
)
```

### AppBar

```dart
AppBar(
  toolbarHeight: 56.h,
  titleSpacing: 16.w,
  title: Text(
    'Title',
    style: TextStyle(fontSize: 20.sp),
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.settings, size: 24.sp),
      padding: EdgeInsets.all(12.w),
      onPressed: () {},
    ),
  ],
)
```

## Migration Steps for Existing Widgets

1. **Add Import**

   ```dart
   import 'package:flutter_screenutil/flutter_screenutil.dart';
   ```

2. **Find & Replace Pattern** (use IDE search):

   - `EdgeInsets.all(` → Add `.w` to numbers
   - `EdgeInsets.symmetric(horizontal:` → Add `.w`
   - `EdgeInsets.symmetric(vertical:` → Add `.h`
   - `SizedBox(height:` → Add `.h`
   - `SizedBox(width:` → Add `.w`
   - `BorderRadius.circular(` → Add `.r`
   - `fontSize:` → Add `.sp`
   - `size:` (for icons) → Add `.sp`

3. **Test** on different screen sizes

## Status: Current Implementation

### ✅ Completed

- [x] ScreenUtil initialized in main.dart
- [x] Helper utilities created (ResponsiveSpacing, ResponsiveFontSizes)
- [x] All button widgets updated
- [x] Documentation created

### ⏳ In Progress

- [ ] Input widgets conversion
- [ ] Card widgets conversion
- [ ] Common widgets conversion

### 📋 Todo

- [ ] Complete all widgets conversion (80+ files)
- [ ] Update all screens (6+ files)
- [ ] Update all templates (5 files)
- [ ] Test on multiple devices
- [ ] Add device preview for testing

## Testing

Run the app and test on:

- [ ] Small phone (iPhone SE - 375x667)
- [ ] Standard phone (iPhone 11 - 414x896)
- [ ] Large phone (iPhone 14 Pro Max - 430x932)
- [ ] Tablet (iPad - 768x1024)

## Notes

- **Design Size**: Using 375x812 (iPhone 11 Pro) as baseline
- **Approach**: Progressive enhancement - core widgets first, then screens
- **Pattern**: All hardcoded px values → responsive extensions
- **Goal**: Consistent UI across all screen sizes and orientations

---

**Quick Tip:** Use the `ResponsiveSpacing` and `ResponsiveFontSizes` helper classes instead of hardcoded values for better consistency!
