# Flutter ScreenUtil - Proper Responsive Design Guide

## Understanding ScreenUtil Extensions

ScreenUtil provides different extension methods for different use cases. Using the wrong one can cause layout issues in landscape/portrait orientations.

### Extension Methods Explained

#### 1. `.w` - Width Scaling

```dart
// Scales based on screen WIDTH
double value = 100.w;
```

- **Use for**: Horizontal spacing, horizontal padding, element widths
- **Adapts to**: Screen width changes (portrait ↔ landscape)
- **Formula**: `(your_value / design_width) * screen_width`

#### 2. `.h` - Height Scaling

```dart
// Scales based on screen HEIGHT
double value = 100.h;
```

- **Use for**: Vertical spacing, vertical padding, element heights
- **Adapts to**: Screen height changes (portrait ↔ landscape)
- **Formula**: `(your_value / design_height) * screen_height`

#### 3. `.sp` - Scalable Pixels (Font Size)

```dart
// Scales for text, adapts to accessibility settings
double fontSize = 16.sp;
```

- **Use for**: Font sizes, icon sizes (when they should scale with text)
- **Adapts to**: Screen size AND user's text scaling preferences
- **Formula**: `(your_value / design_width) * screen_width * text_scale_factor`
- **Best for**: Accessibility-friendly text sizing

#### 4. `.r` - Radius Scaling

```dart
// Scales proportionally to screen size
double radius = 12.r;
```

- **Use for**: Border radius, circular elements, square dimensions
- **Adapts to**: Proportionally to screen size (smaller dimension)
- **Formula**: `(your_value / design_width) * min(screen_width, screen_height)`
- **Best for**: Maintaining circular/square proportions across devices

### ❌ Common Mistakes

#### Mistake 1: Using `.w` for ALL dimensions

```dart
// ❌ BAD - Height uses width scaling
Container(
  width: 100.w,  // ✅ Correct
  height: 50.w,  // ❌ Wrong! Will be inconsistent in landscape
)

// ✅ GOOD
Container(
  width: 100.w,   // Horizontal dimension
  height: 50.h,   // Vertical dimension
)
```

#### Mistake 2: Using `.h` and `.w` for padding inconsistently

```dart
// ❌ BAD - Mixing dimensions incorrectly
EdgeInsets.all(16.w)  // ❌ Top/bottom will be wrong in landscape

// ✅ GOOD - Use symmetric for different dimensions
EdgeInsets.symmetric(
  horizontal: 16.w,  // Left/right
  vertical: 12.h,    // Top/bottom
)
```

#### Mistake 3: Using dimension extensions for font sizes

```dart
// ❌ BAD - Text won't scale properly with accessibility settings
Text('Hello', style: TextStyle(fontSize: 14.w))

// ✅ GOOD - Use .sp for text
Text('Hello', style: TextStyle(fontSize: 14.sp))
```

#### Mistake 4: Using `.w` or `.h` in `const` expressions

```dart
// ❌ BAD - Extension methods can't be used in const
const EdgeInsets.all(16.w)

// ✅ GOOD - Remove const keyword
EdgeInsets.all(16.w)
```

---

## Best Practices

### 1. Padding & Margins

```dart
// ✅ Proper usage with helper methods
import 'package:your_app/core/utils/responsive_utils.dart';

// All sides equal - use our helper
padding: ResponsiveSpacing.all(16),

// Horizontal and vertical different
padding: ResponsiveSpacing.symmetric(
  horizontal: 16,
  vertical: 12,
),

// Different for each side
padding: ResponsiveSpacing.only(
  left: 16,
  top: 12,
  right: 16,
  bottom: 24,
),

// Or use extensions directly
padding: EdgeInsets.symmetric(
  horizontal: 16.w,  // Scales with width
  vertical: 12.h,    // Scales with height
),
```

### 2. Element Sizing

```dart
// ✅ Container with responsive dimensions
Container(
  width: 200.w,      // Horizontal size
  height: 150.h,     // Vertical size
  child: ...
)

// ✅ Square container (maintains aspect ratio)
Container(
  width: 100.r,      // Use .r for squares
  height: 100.r,     // Both same value with .r
  child: ...
)

// ✅ Circular avatar (perfect circle)
CircleAvatar(
  radius: 24.r,      // Use .r for circular elements
  child: ...
)
```

### 3. Spacing (SizedBox)

```dart
// ✅ Horizontal spacing
SizedBox(width: 16.w)

// ✅ Vertical spacing
SizedBox(height: 12.h)

// ✅ Both dimensions
SizedBox(
  width: 100.w,
  height: 50.h,
)
```

### 4. Border Radius

```dart
// ✅ Circular border radius (adapts proportionally)
BorderRadius.circular(12.r)

// ✅ Different radii for each corner
BorderRadius.only(
  topLeft: Radius.circular(16.r),
  topRight: Radius.circular(16.r),
  bottomLeft: Radius.circular(0),
  bottomRight: Radius.circular(0),
)
```

### 5. Text Styling

```dart
// ✅ Always use .sp for text
TextStyle(
  fontSize: 14.sp,           // Adapts to screen size AND accessibility
  letterSpacing: 0.5.sp,     // Letter spacing also uses .sp
  height: 1.5,               // Line height is a multiplier, no extension
)
```

### 6. Icon Sizing

```dart
// ✅ Icons that should scale with text (in buttons, etc.)
Icon(Icons.add, size: 20.sp)

// ✅ Icons with fixed visual size
Icon(Icons.menu, size: 24.r)

// Choose based on context:
// - .sp if icon is part of text/button (should scale with accessibility)
// - .r if icon should maintain proportions
```

---

## Using ResponsiveSpacing Helper Class

We've created helper methods to make responsive design easier:

```dart
import 'package:your_app/core/utils/responsive_utils.dart';

// Pre-defined spacing values (consistent across app)
ResponsiveSpacing.xs     // 4.w
ResponsiveSpacing.sm     // 8.w
ResponsiveSpacing.md     // 12.w
ResponsiveSpacing.lg     // 16.w
ResponsiveSpacing.xl     // 20.w
ResponsiveSpacing.xxl    // 24.w
ResponsiveSpacing.xxxl   // 32.w

// Vertical spacing (different from horizontal)
ResponsiveSpacing.verticalSm   // 8.h
ResponsiveSpacing.verticalMd   // 12.h
ResponsiveSpacing.verticalLg   // 16.h

// Border radius
ResponsiveSpacing.radiusSm   // 8.r
ResponsiveSpacing.radiusMd   // 12.r
ResponsiveSpacing.radiusLg   // 16.r

// Icon sizes
ResponsiveSpacing.iconSm   // 20.sp
ResponsiveSpacing.iconMd   // 24.sp
ResponsiveSpacing.iconLg   // 32.sp

// Font sizes
ResponsiveFontSizes.sm   // 12.sp
ResponsiveFontSizes.md   // 14.sp
ResponsiveFontSizes.lg   // 16.sp
ResponsiveFontSizes.xl   // 18.sp
```

### Example Usage

```dart
// ✅ Using pre-defined constants
Container(
  padding: ResponsiveSpacing.all(ResponsiveSpacing.lg),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusMd),
  ),
  child: Column(
    children: [
      Icon(Icons.star, size: ResponsiveSpacing.iconMd),
      SizedBox(height: ResponsiveSpacing.verticalMd),
      Text(
        'Hello World',
        style: TextStyle(fontSize: ResponsiveFontSizes.lg),
      ),
    ],
  ),
)
```

---

## Orientation-Aware Layouts

For complex layouts that need different structures in portrait vs landscape:

```dart
import 'package:your_app/core/utils/responsive_utils.dart';

@override
Widget build(BuildContext context) {
  // Check orientation
  if (context.isLandscape) {
    return _buildLandscapeLayout();
  } else {
    return _buildPortraitLayout();
  }
}

// Or use LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > constraints.maxHeight) {
      // Landscape
      return Row(...);
    } else {
      // Portrait
      return Column(...);
    }
  },
)
```

---

## Device-Specific Layouts

For different layouts on mobile, tablet, and desktop:

```dart
import 'package:your_app/core/utils/responsive_utils.dart';

// Get different values for different devices
final padding = ResponsiveBreakpoints.valueForDevice(
  context: context,
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

// Or check device type
if (ResponsiveBreakpoints.isMobile(context)) {
  // Show mobile layout
} else if (ResponsiveBreakpoints.isTablet(context)) {
  // Show tablet layout
} else {
  // Show desktop layout
}
```

---

## Quick Reference Table

| Use Case           | Extension | Example | When to Use                                 |
| ------------------ | --------- | ------- | ------------------------------------------- |
| Width / Horizontal | `.w`      | `100.w` | Element widths, horizontal padding/margin   |
| Height / Vertical  | `.h`      | `50.h`  | Element heights, vertical padding/margin    |
| Font Size          | `.sp`     | `16.sp` | All text sizes, icon sizes in text contexts |
| Border Radius      | `.r`      | `12.r`  | All border radius, circular elements        |
| Square Dimensions  | `.r`      | `100.r` | Square containers, equal width/height       |

---

## Testing Responsive Design

### 1. Test Different Orientations

```dart
// Rotate device or use emulator rotation
// Portrait: 375x812 (iPhone 11)
// Landscape: 812x375
```

### 2. Test Different Screen Sizes

- **Small Phone**: 320x568 (iPhone SE)
- **Standard Phone**: 375x812 (iPhone 11)
- **Large Phone**: 430x932 (iPhone 14 Pro Max)
- **Tablet**: 768x1024 (iPad)

### 3. Test Text Scaling

```dart
// In device settings, increase text size
// Your .sp values should scale accordingly
```

---

## Migration Checklist

- [ ] Replace all hardcoded pixel values with responsive extensions
- [ ] Use `.w` for horizontal dimensions
- [ ] Use `.h` for vertical dimensions
- [ ] Use `.sp` for all font sizes and text-related icons
- [ ] Use `.r` for border radius and circular elements
- [ ] Remove `const` keyword where using extensions
- [ ] Use `ResponsiveSpacing` helpers for consistency
- [ ] Test in both portrait and landscape orientations
- [ ] Test on different screen sizes (phone, tablet)
- [ ] Test with increased text scaling (accessibility)

---

## Common Patterns

### Button with Icon and Text

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.add, size: 20.sp),  // .sp to scale with text
  label: Text(
    'Add Item',
    style: TextStyle(fontSize: 14.sp),
  ),
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 12.h,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
  ),
)
```

### Card with Content

```dart
Card(
  margin: EdgeInsets.all(12.w),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.r),
  ),
  child: Padding(
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Description text here',
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    ),
  ),
)
```

### Avatar with Badge

```dart
Stack(
  children: [
    CircleAvatar(
      radius: 24.r,  // .r maintains circular shape
      backgroundImage: NetworkImage(imageUrl),
    ),
    Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        width: 16.r,   // .r for circular badge
        height: 16.r,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2.w,
          ),
        ),
      ),
    ),
  ],
)
```

---

## Summary

✅ **DO**:

- Use `.w` for horizontal dimensions
- Use `.h` for vertical dimensions
- Use `.sp` for text and accessibility-aware sizing
- Use `.r` for radius and proportional elements
- Remove `const` when using extensions
- Test in multiple orientations

❌ **DON'T**:

- Mix `.w` and `.h` incorrectly
- Use `.w` or `.h` for text sizing
- Use extensions in `const` expressions
- Hardcode pixel values
- Forget to test landscape mode
