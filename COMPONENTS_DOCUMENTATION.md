# Flutter Clean Architecture - Component Library Documentation

## Table of Contents

- [Introduction](#introduction)
- [Theme System](#theme-system)
  - [Color Palette](#color-palette)
  - [Typography](#typography)
  - [Theme Switching](#theme-switching)
- [Component Library](#component-library)
  - [Buttons](#buttons)
  - [Text Fields](#text-fields)
  - [Cards](#cards)
  - [App Bars](#app-bars)
  - [Bottom Sheets](#bottom-sheets)
  - [Dialogs](#dialogs)
  - [Snackbars](#snackbars)
  - [Loading Indicators](#loading-indicators)
  - [Empty States](#empty-states)
  - [Error Widgets](#error-widgets)
- [State Management](#state-management)
- [Navigation](#navigation)
- [Demo Page](#demo-page)
- [Future Enhancements](#future-enhancements)
- [TODO Checklist](#todo-checklist)

---

## Introduction

This Flutter Clean Architecture project has been enhanced with a comprehensive component library featuring:

- ✅ Custom light and dark theme support
- ✅ 40+ reusable widget components
- ✅ Riverpod state management integration
- ✅ GoRouter navigation setup
- ✅ Interactive demo page showcase
- ✅ Material Design 3 principles

All components are theme-aware, accessible, and follow clean architecture principles.

---

## Theme System

### Color Palette

#### Primary Colors (Indigo)

```dart
// Light Theme
AppColors.primaryLight      // #6366F1 - Main brand color
AppColors.primaryLightBg    // #EEF2FF - Backgrounds
AppColors.onPrimaryLight    // #FFFFFF - Text on primary

// Dark Theme
AppColors.primaryDark       // #818CF8 - Main brand color (dark)
AppColors.primaryDarkBg     // #1E1B4B - Backgrounds
AppColors.onPrimaryDark     // #FFFFFF - Text on primary
```

#### Secondary Colors (Emerald)

```dart
// Light Theme
AppColors.secondaryLight    // #10B981 - Accent actions
AppColors.secondaryLightBg  // #ECFDF5 - Backgrounds
AppColors.onSecondaryLight  // #FFFFFF - Text on secondary

// Dark Theme
AppColors.secondaryDark     // #34D399 - Accent actions (dark)
AppColors.secondaryDarkBg   // #064E3B - Backgrounds
AppColors.onSecondaryDark   // #000000 - Text on secondary
```

#### Status Colors

```dart
AppColors.success           // #10B981 - Success states
AppColors.warning           // #F59E0B - Warning states
AppColors.error             // #EF4444 - Error states
AppColors.info              // #3B82F6 - Info states

// Backgrounds
AppColors.successBg         // #ECFDF5
AppColors.warningBg         // #FEF3C7
AppColors.errorBg           // #FEE2E2
AppColors.infoBg            // #DBEAFE
```

#### Neutral Colors

```dart
// Light Theme
AppColors.backgroundLight   // #FFFFFF
AppColors.surfaceLight      // #F9FAFB
AppColors.textPrimaryLight  // #1F2937
AppColors.textSecondaryLight // #6B7280

// Dark Theme
AppColors.backgroundDark    // #0F172A
AppColors.surfaceDark       // #1E293B
AppColors.textPrimaryDark   // #F1F5F9
AppColors.textSecondaryDark // #94A3B8
```

#### Gradients

```dart
AppColors.primaryGradient   // Indigo gradient
AppColors.secondaryGradient // Emerald gradient
AppColors.successGradient   // Success gradient
AppColors.errorGradient     // Error gradient
```

### Typography

All text styles follow Material Design 3 typography:

```dart
// Display Styles (Large headings)
AppTextStyles.displayLarge(context)   // 57px, bold
AppTextStyles.displayMedium(context)  // 45px, bold
AppTextStyles.displaySmall(context)   // 36px, bold

// Headline Styles (Section headers)
AppTextStyles.headlineLarge(context)  // 32px, bold
AppTextStyles.headlineMedium(context) // 28px, bold
AppTextStyles.headlineSmall(context)  // 24px, bold

// Title Styles (Card titles, dialog titles)
AppTextStyles.titleLarge(context)     // 22px, semibold
AppTextStyles.titleMedium(context)    // 16px, medium
AppTextStyles.titleSmall(context)     // 14px, medium

// Body Styles (Main content)
AppTextStyles.bodyLarge(context)      // 16px, regular
AppTextStyles.bodyMedium(context)     // 14px, regular
AppTextStyles.bodySmall(context)      // 12px, regular

// Label Styles (Buttons, chips)
AppTextStyles.labelLarge(context)     // 14px, medium
AppTextStyles.labelMedium(context)    // 12px, medium
AppTextStyles.labelSmall(context)     // 11px, medium
```

**Usage Example:**

```dart
Text(
  'Hello World',
  style: AppTextStyles.headlineMedium(context),
)
```

### Theme Switching

Theme is managed via Riverpod with persistent storage:

```dart
// Access theme in any widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Text('Current: $themeMode');
  }
}

// Toggle theme
ref.read(themeModeProvider.notifier).toggleTheme();

// Set specific mode
ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
```

---

## Component Library

### Buttons

#### Primary Button

Standard button with loading state and icon support.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
```

**Usage:**

```dart
PrimaryButton(
  text: 'Submit',
  onPressed: () => print('Pressed'),
  icon: Icons.check,
  isLoading: false,
  width: double.infinity,
  height: 48,
)
```

**Parameters:**

- `text` (required) - Button label
- `onPressed` (required) - Callback function
- `icon` (optional) - Leading icon
- `isLoading` (optional) - Shows loading indicator
- `width` (optional) - Custom width
- `height` (optional) - Custom height (default: 48)

#### Secondary Button

Button with secondary color styling.

**Usage:**

```dart
SecondaryButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
)
```

#### Outline Button

Button with outline style and no fill.

**Usage:**

```dart
AppOutlineButton(
  text: 'Learn More',
  onPressed: () => print('Info'),
  icon: Icons.info_outline,
  borderColor: Colors.blue,
  foregroundColor: Colors.blue,
)
```

**Parameters:**

- `borderColor` (optional) - Custom border color
- `foregroundColor` (optional) - Custom text/icon color

#### Icon Buttons

Circular and custom icon buttons.

**Usage:**

```dart
// Custom Icon Button
CustomIconButton(
  icon: Icons.settings,
  onPressed: () => print('Settings'),
  tooltip: 'Settings',
)

// Circular Icon Button
CircularIconButton(
  icon: Icons.add,
  onPressed: () => print('Add'),
  backgroundColor: AppColors.primaryLight,
  foregroundColor: Colors.white,
  size: 56,
)
```

---

### Text Fields

#### AppTextField

Base text field with validation support.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/inputs/app_text_field.dart';
```

**Usage:**

```dart
AppTextField(
  label: 'Full Name',
  hint: 'Enter your name',
  controller: nameController,
  prefixIcon: Icons.person,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';
    return null;
  },
)
```

**Specialized Variants:**

```dart
// Email Field
EmailTextField(
  controller: emailController,
  onChanged: (value) => print(value),
)

// Phone Field
PhoneTextField(
  controller: phoneController,
)

// Search Field
SearchTextField(
  hint: 'Search...',
  onChanged: (value) => performSearch(value),
)
```

#### Password Text Field

Password field with strength indicator.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/inputs/password_text_field.dart';
```

**Usage:**

```dart
PasswordTextField(
  controller: passwordController,
  showStrengthIndicator: true,
  onStrengthChanged: (strength) {
    print('Password strength: $strength');
  },
)

// Confirm Password Field
ConfirmPasswordTextField(
  controller: confirmPasswordController,
  passwordController: passwordController,
)
```

**Password Strength Levels:**

- `PasswordStrength.weak` - Red indicator
- `PasswordStrength.medium` - Orange indicator
- `PasswordStrength.strong` - Green indicator

#### Multiline Text Field

Text area for longer content.

**Usage:**

```dart
MultilineTextField(
  label: 'Description',
  controller: descController,
  maxLines: 5,
  maxLength: 500,
)

// Comment Field
CommentTextField(
  controller: commentController,
)

// Description Field
DescriptionTextField(
  controller: descriptionController,
)
```

---

### Cards

#### Product Card

Card for displaying products with image, badge, and favorite action.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/cards/product_card.dart';
```

**Usage:**

```dart
ProductCard(
  imageUrl: 'https://example.com/product.jpg',
  title: 'Premium Watch',
  description: 'Luxury timepiece',
  price: '\$299',
  rating: 4.5,
  badge: 'NEW',
  isFavorite: false,
  onTap: () => print('Product tapped'),
  onFavoriteToggle: () => print('Favorite toggled'),
)

// Horizontal Variant
HorizontalProductCard(
  imageUrl: 'https://example.com/product.jpg',
  title: 'Product',
  description: 'Description',
  price: '\$99',
  onTap: () => print('Tapped'),
)
```

#### Info Card

Card for displaying information with icon and optional action.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/cards/info_card.dart';
```

**Usage:**

```dart
InfoCard(
  icon: Icons.info,
  title: 'Important Notice',
  description: 'This is important information',
  iconColor: AppColors.info,
  onTap: () => print('Info tapped'),
)

// Stat Card (for metrics)
StatCard(
  icon: Icons.trending_up,
  value: '1,234',
  label: 'Total Sales',
  color: AppColors.success,
)

// Feature Card
FeatureCard(
  icon: Icons.bolt,
  title: 'Fast Performance',
  description: 'Lightning-fast loading times',
  iconColor: AppColors.warning,
)
```

#### Custom Card

Flexible card templates.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/cards/custom_card.dart';
```

**Usage:**

```dart
// Basic Custom Card
CustomCard(
  padding: EdgeInsets.all(16),
  elevation: 2,
  borderRadius: 12,
  child: Text('Custom content'),
)

// Header Card
HeaderCard(
  title: 'Settings',
  subtitle: 'Manage your preferences',
  icon: Icons.settings,
  trailing: Icon(Icons.chevron_right),
  onTap: () => print('Settings'),
)

// Expandable Card
ExpandableCard(
  title: 'Advanced Options',
  children: [
    ListTile(title: Text('Option 1')),
    ListTile(title: Text('Option 2')),
  ],
)
```

---

### App Bars

#### Custom App Bar

Standard app bar with customization options.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/app_bars/custom_app_bar.dart';
```

**Usage:**

```dart
Scaffold(
  appBar: CustomAppBar(
    title: 'My Page',
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => print('Search'),
      ),
    ],
  ),
)
```

#### Search App Bar

App bar with integrated search field.

**Usage:**

```dart
SearchAppBar(
  title: 'Search Products',
  onSearch: (query) {
    print('Searching: $query');
  },
)
```

#### Theme App Bar

App bar with theme toggle button.

**Usage:**

```dart
ThemeAppBar(
  title: 'Settings',
  onThemeToggle: () {
    ref.read(themeModeProvider.notifier).toggleTheme();
  },
)
```

#### Tab App Bar

App bar with tab navigation.

**Usage:**

```dart
TabAppBar(
  title: 'Dashboard',
  tabs: [
    Tab(text: 'Overview'),
    Tab(text: 'Analytics'),
    Tab(text: 'Reports'),
  ],
)
```

---

### Bottom Sheets

#### Modal Bottom Sheet

Show bottom sheet modal.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/bottom_sheets/modal_bottom_sheet.dart';
```

**Usage:**

```dart
// Simple Modal
showAppModalBottomSheet(
  context: context,
  title: 'Choose Option',
  child: Column(
    children: [
      ListTile(title: Text('Option 1')),
      ListTile(title: Text('Option 2')),
    ],
  ),
);

// Scrollable Bottom Sheet
ScrollableBottomSheet(
  title: 'Terms & Conditions',
  child: Text('Long content...'),
)

// List Bottom Sheet
ListBottomSheet<String>(
  title: 'Select Country',
  items: ['USA', 'Canada', 'UK'],
  itemBuilder: (context, item) => ListTile(
    title: Text(item),
  ),
  onItemSelected: (item) {
    print('Selected: $item');
  },
)
```

---

### Dialogs

All dialog methods are static utilities.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_dialogs.dart';
```

**Usage:**

```dart
// Info Dialog
AppDialogs.showInfoDialog(
  context: context,
  title: 'Information',
  message: 'Here is some information',
  buttonText: 'Got it',
);

// Success Dialog
AppDialogs.showSuccessDialog(
  context: context,
  title: 'Success',
  message: 'Operation completed successfully',
);

// Error Dialog
AppDialogs.showErrorDialog(
  context: context,
  title: 'Error',
  message: 'Something went wrong',
);

// Warning Dialog
AppDialogs.showWarningDialog(
  context: context,
  title: 'Warning',
  message: 'Are you sure?',
);

// Confirm Dialog
final confirmed = await AppDialogs.showConfirmDialog(
  context: context,
  title: 'Confirm',
  message: 'Do you want to proceed?',
  confirmText: 'Yes',
  cancelText: 'No',
);

// Delete Confirm Dialog
final shouldDelete = await AppDialogs.showDeleteConfirmDialog(
  context: context,
  itemName: 'this item',
);

// Loading Dialog
AppDialogs.showLoadingDialog(
  context: context,
  message: 'Please wait...',
);
// Close with Navigator.pop(context)
```

---

### Snackbars

All snackbar methods are static utilities.

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_snackbars.dart';
```

**Usage:**

```dart
// Info Snackbar
AppSnackbars.showInfo(
  context: context,
  message: 'This is informational',
);

// Success Snackbar
AppSnackbars.showSuccess(
  context: context,
  message: 'Successfully saved!',
);

// Error Snackbar
AppSnackbars.showError(
  context: context,
  message: 'Failed to save',
);

// Warning Snackbar
AppSnackbars.showWarning(
  context: context,
  message: 'Please review your input',
);

// Custom Snackbar with Action
AppSnackbars.showCustom(
  context: context,
  message: 'Item deleted',
  icon: Icons.delete,
  backgroundColor: Colors.red,
  action: AppSnackbarAction(
    label: 'UNDO',
    onPressed: () => print('Undo delete'),
  ),
);
```

---

### Loading Indicators

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/common/loading_indicator.dart';
```

**Usage:**

```dart
// Simple Loading Indicator
AppLoadingIndicator()

// With message
AppLoadingIndicator(message: 'Loading...')

// Loading Overlay
LoadingOverlay(
  isLoading: true,
  child: YourWidget(),
)

// Linear Progress
AppLinearProgress()

// Shimmer Loading Effect
ShimmerLoading(
  width: 200,
  height: 100,
  borderRadius: 8,
)

// Skeleton Placeholder
SkeletonPlaceholder(
  width: double.infinity,
  height: 200,
)
```

---

### Empty States

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/common/empty_state.dart';
```

**Usage:**

```dart
// Generic Empty State
EmptyState(
  icon: Icons.inbox,
  message: 'No items found',
  description: 'Try adding some items',
  actionLabel: 'Add Item',
  onAction: () => print('Add'),
)

// Empty Search Results
EmptySearchResults()

// Empty List
EmptyList(
  message: 'No products yet',
  actionLabel: 'Browse Products',
  onAction: () => print('Browse'),
)

// No Data
NoData()

// No Internet Connection
NoInternetConnection(
  onRetry: () => print('Retry'),
)
```

---

### Error Widgets

**Import:**

```dart
import 'package:flutter_clean_architecture/shared/widgets/common/error_widget.dart';
```

**Usage:**

```dart
// Generic Error Widget
AppErrorWidget(
  message: 'Failed to load data',
  onRetry: () => print('Retry'),
)

// Network Error
NetworkErrorWidget(
  onRetry: () => print('Retry'),
)

// Server Error
ServerErrorWidget(
  onRetry: () => print('Retry'),
)

// Something Went Wrong
SomethingWentWrong(
  onRetry: () => print('Retry'),
)

// Inline Error Message
InlineErrorMessage(
  message: 'Invalid input',
)
```

---

## State Management

### Riverpod Integration

**Theme Management:**

```dart
// Provider definition (already created)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

// Usage in ConsumerWidget
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme changes
    final themeMode = ref.watch(themeModeProvider);

    // Update theme
    final updateTheme = () {
      ref.read(themeModeProvider.notifier).toggleTheme();
    };

    return Scaffold(
      body: ElevatedButton(
        onPressed: updateTheme,
        child: Text('Toggle Theme'),
      ),
    );
  }
}
```

**Creating New Providers:**

```dart
// TODO: Create providers for your features
// Example: Counter provider
final counterProvider = StateProvider<int>((ref) => 0);

// Example: Async data provider
final dataProvider = FutureProvider<List<Item>>((ref) async {
  return fetchDataFromAPI();
});

// Example: State notifier for complex state
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState.initial());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(),
);
```

---

## Navigation

### GoRouter Setup

**Route Definitions:**

```dart
// lib/router/routes.dart
abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const demo = '/demo';  // Demo page route
}
```

**Navigation Examples:**

```dart
// Navigate to route
context.go(Routes.demo);

// Navigate with push
context.push(Routes.demo);

// Navigate with parameters
context.go('/product/123');

// Go back
context.pop();

// Replace current route
context.replace(Routes.login);
```

**Adding New Routes:**

```dart
// TODO: Add routes for your features
// 1. Add route constant to Routes class
static const myNewRoute = '/my-new-route';

// 2. Add GoRoute to AppRouter
GoRoute(
  path: Routes.myNewRoute,
  builder: (context, state) => const MyNewScreen(),
),
```

---

## Demo Page

### Accessing Demo Page

Navigate to the demo page to see all components in action:

```dart
context.go(Routes.demo);
```

Or from command line:

```bash
flutter run
# Then navigate to /demo route
```

### Demo Page Features

The demo page includes 7 tabs:

1. **Buttons Tab** - All button variants with examples
2. **Inputs Tab** - Text fields with validation
3. **Cards Tab** - Product, info, and custom cards
4. **Dialogs Tab** - All dialog and snackbar types
5. **States Tab** - Loading, empty, and error states
6. **Theme Tab** - Theme switcher and color palette
7. **All Components Tab** - Complete overview

**Location:**

```
lib/features/demo/presentation/screens/demo_page.dart
```

---

## Future Enhancements

### TODO Checklist

#### Components to Add

```dart
// TODO: Add more input components
// - [ ] Date picker field
// - [ ] Time picker field
// - [ ] Dropdown select field
// - [ ] Radio button group
// - [ ] Checkbox group
// - [ ] Switch toggle
// - [ ] Slider input
// - [ ] File upload field

// TODO: Add navigation components
// - [ ] Bottom navigation bar
// - [ ] Side drawer
// - [ ] Tab bar view
// - [ ] Stepper widget

// TODO: Add data display components
// - [ ] Data table
// - [ ] List tile variants
// - [ ] Chip widgets
// - [ ] Badge components
// - [ ] Avatar widgets
// - [ ] Timeline widget

// TODO: Add feedback components
// - [ ] Progress bar (determinate)
// - [ ] Tooltip widget
// - [ ] Banner component
// - [ ] Alert component

// TODO: Add layout components
// - [ ] Grid view wrapper
// - [ ] Sliver app bar
// - [ ] Collapsible sections
// - [ ] Carousel/Slider
// - [ ] Page view indicator

// TODO: Add media components
// - [ ] Image viewer
// - [ ] Video player wrapper
// - [ ] Audio player widget
// - [ ] Image carousel
```

#### Theme Enhancements

```dart
// TODO: Add more theme customization
// - [ ] Custom font family support
// - [ ] Theme presets (e.g., Ocean, Forest, Sunset)
// - [ ] Dynamic color extraction from images
// - [ ] Animated theme transitions
// - [ ] Per-component theme overrides
```

#### State Management

```dart
// TODO: Add more state management patterns
// - [ ] Form state management with Riverpod
// - [ ] Pagination state provider
// - [ ] Search/filter state provider
// - [ ] Shopping cart state example
// - [ ] Authentication state management
```

#### Accessibility

```dart
// TODO: Enhance accessibility
// - [ ] Add semantic labels to all components
// - [ ] Test with TalkBack/VoiceOver
// - [ ] Add focus management
// - [ ] Add keyboard navigation
// - [ ] Ensure proper contrast ratios
```

#### Testing

```dart
// TODO: Add comprehensive tests
// - [ ] Widget tests for all components
// - [ ] Integration tests for flows
// - [ ] Golden tests for visual regression
// - [ ] Unit tests for providers
```

#### Documentation

```dart
// TODO: Enhance documentation
// - [ ] Add video tutorials
// - [ ] Create interactive playground
// - [ ] Generate API documentation
// - [ ] Add architecture decision records (ADRs)
```

---

## Quick Start Guide

### 1. Using Components

Import the component:

```dart
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
```

Use in your widget:

```dart
PrimaryButton(
  text: 'Click Me',
  onPressed: () => print('Clicked'),
)
```

### 2. Accessing Theme

```dart
// In any widget
final theme = Theme.of(context);
final colors = theme.colorScheme;

// Use theme colors
Container(
  color: colors.primary,
  child: Text('Hello', style: theme.textTheme.headlineSmall),
)
```

### 3. Managing State

```dart
// Consumer widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return Text('$state');
  }
}
```

### 4. Navigating

```dart
// Navigate to demo
context.go(Routes.demo);

// Navigate back
context.pop();
```

---

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          # Color palette
│   │   ├── app_text_styles.dart     # Typography
│   │   └── app_theme.dart           # Theme configuration
│   └── providers/
│       └── theme_provider.dart      # Theme state management
├── shared/
│   └── widgets/
│       ├── buttons/                 # Button components
│       ├── inputs/                  # Text field components
│       ├── cards/                   # Card components
│       ├── app_bars/                # App bar variants
│       ├── bottom_sheets/           # Bottom sheet utilities
│       ├── dialogs/                 # Dialog & snackbar utilities
│       └── common/                  # Loading, empty, error widgets
├── features/
│   └── demo/
│       └── presentation/
│           └── screens/
│               └── demo_page.dart   # Component showcase
└── router/
    ├── routes.dart                  # Route constants
    └── app_router.dart              # GoRouter configuration
```

---

## Best Practices

### Component Usage

1. **Always use theme colors** instead of hardcoded colors
2. **Use AppTextStyles** for consistent typography
3. **Add validation** to all form inputs
4. **Show loading states** during async operations
5. **Handle errors gracefully** with error widgets

### State Management

1. **Keep providers focused** on single responsibility
2. **Use StateNotifier** for complex state logic
3. **Avoid excessive rebuilds** by watching specific providers
4. **Persist important state** with SharedPreferences

### Navigation

1. **Use named routes** from Routes class
2. **Pass data via route parameters** not global state
3. **Implement guards** for protected routes
4. **Handle deep links** for better UX

### Theming

1. **Test both light and dark themes** during development
2. **Use semantic colors** (primary, secondary, error) not specific hues
3. **Ensure sufficient contrast** for accessibility
4. **Animate theme transitions** for smooth changes

---

## Contributing

When adding new components:

1. **Follow the existing structure** in `shared/widgets/`
2. **Create reusable, customizable widgets**
3. **Add TODO comments** for customization points
4. **Use theme colors and text styles**
5. **Add to demo page** for visibility
6. **Update this documentation** with usage examples

---

## Support

For issues or questions:

- Review demo page examples
- Check component source code
- Refer to Material Design 3 guidelines
- Review Flutter documentation

---

## License

This template is provided as-is for project scaffolding.

---

**Generated:** Flutter Clean Architecture Template v1.0  
**Last Updated:** Component Library Enhancement Phase  
**Components:** 40+ reusable widgets  
**Theme Support:** Light & Dark modes with custom palette  
**State Management:** flutter_riverpod integration  
**Navigation:** GoRouter setup with demo page

---

**Next Steps:**

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to see the app
3. Navigate to `/demo` to explore all components
4. Start building your features using the component library
5. Customize theme colors in `app_colors.dart`
6. Add new routes in `routes.dart` and `app_router.dart`
7. Create feature-specific providers as needed

**Happy Coding! 🚀**
