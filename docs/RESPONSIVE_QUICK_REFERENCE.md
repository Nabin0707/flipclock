# Quick Reference: ResponsiveSpacing Helpers

## ✅ Updated Files

**12 files now use ResponsiveSpacing helpers**: icon_button, all buttons, all inputs, all cards

---

## Quick Conversion Guide

### EdgeInsets

| Before (Direct)                                          | After (Helper)                                              |
| -------------------------------------------------------- | ----------------------------------------------------------- |
| `EdgeInsets.all(8.w)`                                    | `ResponsiveSpacing.all(8)`                                  |
| `EdgeInsets.all(12.w)`                                   | `ResponsiveSpacing.all(12)`                                 |
| `EdgeInsets.all(16.w)`                                   | `ResponsiveSpacing.all(16)`                                 |
| `EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h)` | `ResponsiveSpacing.symmetric(horizontal: 24, vertical: 12)` |
| `EdgeInsets.only(top: 8.h)`                              | `ResponsiveSpacing.only(top: 8)`                            |

### Font Sizes

| Before            | After                                | Value |
| ----------------- | ------------------------------------ | ----- |
| `fontSize: 10.sp` | `fontSize: ResponsiveFontSizes.xs`   | 10.sp |
| `fontSize: 12.sp` | `fontSize: ResponsiveFontSizes.sm`   | 12.sp |
| `fontSize: 14.sp` | `fontSize: ResponsiveFontSizes.md`   | 14.sp |
| `fontSize: 16.sp` | `fontSize: ResponsiveFontSizes.lg`   | 16.sp |
| `fontSize: 18.sp` | `fontSize: ResponsiveFontSizes.xl`   | 18.sp |
| `fontSize: 20.sp` | `fontSize: ResponsiveFontSizes.xxl`  | 20.sp |
| `fontSize: 24.sp` | `fontSize: ResponsiveFontSizes.xxxl` | 24.sp |

### Icon Sizes

| Before        | After                             | Value |
| ------------- | --------------------------------- | ----- |
| `size: 16.sp` | `size: ResponsiveSpacing.iconXs`  | 16.sp |
| `size: 20.sp` | `size: ResponsiveSpacing.iconSm`  | 20.sp |
| `size: 24.sp` | `size: ResponsiveSpacing.iconMd`  | 24.sp |
| `size: 32.sp` | `size: ResponsiveSpacing.iconLg`  | 32.sp |
| `size: 40.sp` | `size: ResponsiveSpacing.iconXl`  | 40.sp |
| `size: 48.sp` | `size: ResponsiveSpacing.iconXxl` | 48.sp |

### Border Radius

| Before                        | After                                               | Value |
| ----------------------------- | --------------------------------------------------- | ----- |
| `BorderRadius.circular(4.r)`  | `BorderRadius.circular(ResponsiveSpacing.radiusXs)` | 4.r   |
| `BorderRadius.circular(8.r)`  | `BorderRadius.circular(ResponsiveSpacing.radiusSm)` | 8.r   |
| `BorderRadius.circular(12.r)` | `BorderRadius.circular(ResponsiveSpacing.radiusMd)` | 12.r  |
| `BorderRadius.circular(16.r)` | `BorderRadius.circular(ResponsiveSpacing.radiusLg)` | 16.r  |
| `BorderRadius.circular(20.r)` | `BorderRadius.circular(ResponsiveSpacing.radiusXl)` | 20.r  |

---

## Benefits

### 1. Semantic Naming

- `ResponsiveFontSizes.md` is clearer than `14.sp`
- `ResponsiveSpacing.radiusMd` is clearer than `12.r`

### 2. Consistency

- All widgets use the same values
- Easy to maintain design system

### 3. Centralized Changes

- Change once in `responsive_utils.dart`
- Affects all widgets automatically

### 4. Type Safety

- Compile-time constants
- No magic numbers

---

## Usage in New Code

```dart
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// ✅ Use helpers
Container(
  padding: ResponsiveSpacing.all(16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusMd),
  ),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: ResponsiveFontSizes.lg),
  ),
)

// With icons
Icon(
  Icons.star,
  size: ResponsiveSpacing.iconMd,
)

// Complex padding
Container(
  padding: ResponsiveSpacing.symmetric(
    horizontal: 24,
    vertical: 16,
  ),
)
```

---

## Import Required

Add this import to use helpers:

```dart
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';
```

---

**All icon buttons, inputs, and cards now follow this pattern!** ✅
