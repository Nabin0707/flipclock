# New Components Documentation

This document provides comprehensive information about the newly added components to the Flutter Clean Architecture template.

## Table of Contents

- [Overview](#overview)
- [Section Headers](#section-headers)
- [Navigation Drawers](#navigation-drawers)
- [Floating Action Buttons](#floating-action-buttons)
- [Card Overflow Fix](#card-overflow-fix)
- [Usage Examples](#usage-examples)

---

## Overview

Three major component categories have been added to enhance the app's UI capabilities:

1. **Section Headers** - Organize content with styled headers
2. **Navigation Drawers** - User profile and navigation menu
3. **Floating Action Buttons** - Multiple FAB variants including speed dial

All components follow the **theme-controlled design** philosophy where styling comes from `app_theme.dart`, making them fully responsive and consistent across portrait and landscape orientations.

---

## Section Headers

**Location**: `lib/shared/widgets/common/section_header.dart`

### 1. SectionHeader (Basic)

A standard section header with title, optional subtitle, and trailing widget.

**Properties**:

- `title` (required): Section title text
- `subtitle`: Optional description text
- `trailing`: Optional widget (e.g., "View All" button)
- `onTap`: Optional tap callback
- `padding`: Custom padding (defaults to 16.w horizontal, 12.h vertical)

**Example**:

```dart
SectionHeader(
  title: 'Recent Items',
  subtitle: 'Last 7 days',
  trailing: TextButton(
    onPressed: () => print('View All'),
    child: const Text('View All'),
  ),
)
```

### 2. LargeSectionHeader

Prominent header with icon and larger text styling.

**Properties**:

- `icon` (required): Leading icon
- `title` (required): Large section title
- `subtitle`: Optional description
- `trailing`: Optional trailing widget
- `padding`: Custom padding

**Example**:

```dart
LargeSectionHeader(
  icon: Icons.star,
  title: 'Featured Products',
  subtitle: 'Handpicked for you',
)
```

### 3. DividerSectionHeader

Compact header with a divider line extending to the right.

**Properties**:

- `title` (required): Section title
- `padding`: Custom padding

**Example**:

```dart
DividerSectionHeader(
  title: 'Settings',
)
```

**Responsive Sizing**:

- All headers use `.w` for horizontal spacing and `.h` for vertical spacing
- Font sizes use `.sp` for proper text scaling
- Adapts automatically to portrait and landscape modes

---

## Navigation Drawers

**Location**: `lib/shared/widgets/common/app_drawer.dart`

### 1. AppDrawer (Base Component)

Fully customizable drawer with header, menu items, and footer.

**Properties**:

- `header`: Custom header widget
- `items` (required): List of `DrawerItem` objects
- `footer`: Optional footer widget
- `width`: Drawer width (defaults to 280.w)

**Example**:

```dart
AppDrawer(
  header: Container(
    padding: EdgeInsets.all(24.w),
    child: Text('App Name', style: TextStyle(fontSize: 24.sp)),
  ),
  items: [
    DrawerItem(
      icon: Icons.home,
      title: 'Home',
      onTap: () => Navigator.pop(context),
    ),
    DrawerItem(
      icon: Icons.settings,
      title: 'Settings',
      badge: '3',
      onTap: () => print('Settings'),
    ),
    DrawerItem.divider(),
    DrawerItem(
      icon: Icons.logout,
      title: 'Logout',
      onTap: () => print('Logout'),
    ),
  ],
)
```

### 2. ProfileDrawer

Pre-configured drawer with user profile header and gradient background.

**Properties**:

- `userName` (required): User's display name
- `userEmail` (required): User's email address
- `userAvatarUrl`: Optional profile image URL
- `menuItems` (required): List of `DrawerItem` objects
- `onProfileTap`: Optional callback when profile header is tapped

**Example**:

```dart
ProfileDrawer(
  userName: 'John Doe',
  userEmail: 'john.doe@example.com',
  userAvatarUrl: 'https://example.com/avatar.jpg',
  menuItems: [
    DrawerItem(
      icon: Icons.home,
      title: 'Home',
      onTap: () => Navigator.pushNamed(context, '/home'),
    ),
    DrawerItem(
      icon: Icons.notifications,
      title: 'Notifications',
      badge: '5',
      isSelected: true,
      onTap: () => print('Notifications'),
    ),
  ],
  onProfileTap: () => print('Profile tapped'),
)
```

### 3. DrawerItem (Data Class)

Configuration object for drawer menu items.

**Properties**:

- `icon`: Menu item icon
- `title` (required): Item label
- `subtitle`: Optional secondary text
- `trailing`: Custom trailing widget
- `badge`: Badge text (e.g., notification count)
- `onTap`: Tap callback
- `isSelected`: Highlight as selected
- `isDivider`: Render as divider instead of menu item

**Factory Constructor**:

```dart
DrawerItem.divider()  // Creates a divider separator
```

**Features**:

- Badge support with primary color background
- Selection state with theme highlight
- Automatic divider rendering
- Responsive padding and sizing

---

## Floating Action Buttons

**Location**: `lib/shared/widgets/common/app_fab.dart`

### 1. AppFAB (Basic FAB)

Standard floating action button with optional label.

**Properties**:

- `onPressed` (required): Callback function
- `icon`: Button icon (defaults to Icons.add)
- `label`: Optional text label (creates extended FAB)
- `mini`: Smaller size variant
- `heroTag`: Unique tag for Hero animations

**Examples**:

```dart
// Basic FAB
AppFAB(
  icon: Icons.add,
  onPressed: () => print('Add'),
)

// Extended FAB with label
AppFAB(
  icon: Icons.edit,
  label: 'Edit',
  onPressed: () => print('Edit'),
)

// Mini FAB
AppFAB(
  icon: Icons.share,
  mini: true,
  onPressed: () => print('Share'),
)
```

### 2. BadgedFAB

FAB with notification badge overlay.

**Properties**:

- `onPressed` (required): Callback function
- `icon`: Button icon (defaults to Icons.notifications)
- `badgeCount`: Number to display in badge (0 = hidden)
- `heroTag`: Unique tag for Hero animations

**Example**:

```dart
BadgedFAB(
  icon: Icons.message,
  badgeCount: 5,
  onPressed: () => print('Messages'),
)
```

**Features**:

- Badge automatically hidden when count is 0
- Badge styled with error color for visibility
- Positioned at top-right of FAB
- Uses theme colors for consistency

### 3. SpeedDialFAB (Expandable FAB)

Animated FAB that expands to show multiple action buttons.

**Properties**:

- `icon`: Main FAB icon (defaults to Icons.add)
- `children` (required): List of `SpeedDialChild` items
- `heroTag`: Unique tag for Hero animations

**Example**:

```dart
SpeedDialFAB(
  icon: Icons.add,
  children: [
    SpeedDialChild(
      icon: Icons.edit,
      label: 'Edit',
      onPressed: () => print('Edit'),
    ),
    SpeedDialChild(
      icon: Icons.share,
      label: 'Share',
      backgroundColor: Colors.blue,
      onPressed: () => print('Share'),
    ),
    SpeedDialChild(
      icon: Icons.delete,
      label: 'Delete',
      foregroundColor: Colors.red,
      onPressed: () => print('Delete'),
    ),
  ],
)
```

**Features**:

- Smooth expand/collapse animations
- AnimatedIcon (add to close transition)
- ScaleTransition for child buttons
- Each child can have custom colors
- Labels displayed next to child buttons
- Tap outside or main FAB to close

### 4. SpeedDialChild (Data Class)

Configuration for individual speed dial actions.

**Properties**:

- `icon` (required): Action icon
- `label`: Optional text label
- `onPressed`: Callback function
- `backgroundColor`: Custom background color
- `foregroundColor`: Custom icon color
- `heroTag`: Unique tag for Hero animations

### 5. MorphingFAB

FAB that expands into a modal bottom sheet.

**Properties**:

- `onPressed` (required): Callback (triggers sheet)
- `icon` (required): FAB icon
- `expandedChild` (required): Widget to show in bottom sheet
- `heroTag`: Unique tag for Hero animations

**Example**:

```dart
MorphingFAB(
  icon: Icons.add,
  onPressed: () {},
  expandedChild: Container(
    padding: EdgeInsets.all(24.w),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Create New', style: TextStyle(fontSize: 20.sp)),
        SizedBox(height: 16.h),
        // Add your content here
      ],
    ),
  ),
)
```

---

## Card Overflow Fix

**Location**: `lib/shared/widgets/cards/custom_card.dart`

### Problem

Card content (images, text, buttons) could overflow beyond card borders, especially with `borderRadius`.

### Solution

Added `clipBehavior: Clip.antiAlias` to the Material widget in CustomCard:

```dart
Material(
  clipBehavior: Clip.antiAlias,  // ← Added this
  borderRadius: effectiveBorderRadius,
  child: InkWell(...),
)
```

### Impact

- All card variants (CustomCard, HeaderCard, ExpandableCard) now clip content properly
- Content respects border radius
- No visual overflow in portrait or landscape
- Performance impact is negligible

---

## Usage Examples

### Complete Scaffold with All Components

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo')),

      // Navigation Drawer
      drawer: ProfileDrawer(
        userName: 'John Doe',
        userEmail: 'john@example.com',
        menuItems: [
          DrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          DrawerItem(
            icon: Icons.notifications,
            title: 'Notifications',
            badge: '3',
            onTap: () {},
          ),
        ],
      ),

      // Speed Dial FAB
      floatingActionButton: SpeedDialFAB(
        children: [
          SpeedDialChild(
            icon: Icons.edit,
            label: 'Edit',
            onPressed: () {},
          ),
          SpeedDialChild(
            icon: Icons.share,
            label: 'Share',
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Section Header
          LargeSectionHeader(
            icon: Icons.star,
            title: 'Featured',
            subtitle: 'Recommended for you',
          ),

          SizedBox(height: 16.h),

          // Content with proper card overflow handling
          CustomCard(
            child: Column(
              children: [
                Image.network('https://example.com/image.jpg'),
                Text('Card content'),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Another section
          DividerSectionHeader(title: 'More Items'),

          // More content...
        ],
      ),
    );
  }
}
```

### Responsive Patterns

All components follow these responsive patterns from `app_theme.dart`:

| Type                     | Extension | Usage                                    |
| ------------------------ | --------- | ---------------------------------------- |
| Horizontal spacing/width | `.w`      | `EdgeInsets.symmetric(horizontal: 16.w)` |
| Vertical spacing/height  | `.h`      | `SizedBox(height: 12.h)`                 |
| Font sizes               | `.sp`     | `fontSize: 16.sp`                        |
| Border radius            | `.r`      | `BorderRadius.circular(12.r)`            |

These ensure proper scaling in both portrait and landscape orientations.

---

## Integration Notes

### Exports

All new components are exported in `lib/shared/widgets/widget.dart`:

```dart
export './common/app_drawer.dart';
export './common/app_fab.dart';
export './common/section_header.dart';
```

### Theme Configuration

Components use theme values from `app_theme.dart`:

- Colors: `theme.colorScheme.*`
- Text styles: `theme.textTheme.*`
- Spacing: Responsive with `.w` and `.h`
- Sizes: All dimensions use ScreenUtil extensions

### Demo Page

All components are showcased in `lib/features/demo/presentation/screens/demo_page.dart` in the "New Widgets" tab.

---

## Best Practices

1. **Always use theme colors** - Don't hardcode colors
2. **Use responsive sizing** - Always use `.w`, `.h`, `.sp`, `.r` extensions
3. **Badge as String** - DrawerItem badge property expects String (e.g., `'5'` not `5`)
4. **Hero tags** - Provide unique heroTag when using multiple FABs
5. **Divider items** - Use `DrawerItem.divider()` factory for clean separators
6. **SpeedDial children** - Limit to 3-5 actions for good UX
7. **Profile images** - Always provide fallback for network images

---

## Troubleshooting

### SpeedDialFAB not animating

- Ensure parent widget allows `SingleTickerProviderStateMixin`
- Check that `children` list is not empty

### Drawer not opening

- Verify Scaffold has `drawer` property set
- Use `Scaffold.of(context).openDrawer()` to open programmatically

### Badge not showing

- Ensure badge value is String type: `badge: '5'` not `badge: 5`
- Check badge count > 0 for BadgedFAB

### Card overflow still visible

- Verify you're using CustomCard, HeaderCard, or ExpandableCard
- Check that `clipBehavior: Clip.antiAlias` is present in custom implementations

---

## Component Checklist

When adding these components to your screens:

- [ ] Import widgets from `lib/shared/widgets/widget.dart`
- [ ] Use theme colors (no hardcoded colors)
- [ ] Apply responsive sizing (.w, .h, .sp, .r)
- [ ] Provide required parameters
- [ ] Test in both portrait and landscape
- [ ] Verify no overflow issues
- [ ] Check animations work smoothly (FABs)
- [ ] Test drawer navigation
- [ ] Ensure accessibility (semantic labels)

---

## Future Enhancements

Potential improvements for these components:

1. **Section Headers**

   - Collapse/expand functionality
   - Custom icon colors
   - Badge support

2. **Drawers**

   - Multi-level menu items
   - Search functionality
   - Swipe gestures

3. **FABs**
   - More animation styles
   - Directional speed dial (left, top, right)
   - Voice action integration

---

## Summary

These new components provide:

- ✅ Professional UI patterns
- ✅ Full responsive support (portrait + landscape)
- ✅ Theme-controlled styling
- ✅ No hardcoded dimensions
- ✅ Proper overflow handling
- ✅ Smooth animations
- ✅ Comprehensive customization options
- ✅ Production-ready code

All components follow the architectural principle: **Theme = Design Control, Widgets = Functional Only**.
