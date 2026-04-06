# Widgets Export Guide

## Overview

The `lib/shared/widgets/widget.dart` file serves as a **single import point** for all reusable widgets in the application. Instead of importing multiple widget files individually, you can import this one file to access all widgets.

## Usage

### Before (Multiple Imports) ❌

```dart
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/secondary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/inputs/app_text_field.dart';
import 'package:flutter_clean_architecture/shared/widgets/cards/product_card.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/loading_indicator.dart';
// ... and many more
```

### After (Single Import) ✅

```dart
import 'package:flutter_clean_architecture/shared/widgets/widget.dart';
```

That's it! Now you have access to all widgets with just one import.

## Available Widget Categories

### 1. App Bars

- `CustomAppBar` - Customizable app bar with actions and title

### 2. Bottom Sheets

- `ModalBottomSheetWidget` - Modal bottom sheet for user interactions
- `PersistentBottomSheet` - Persistent bottom sheet
- `ScrollableBottomSheet` - Scrollable bottom sheet for long content

### 3. Buttons

- `PrimaryButton` - Main action button
- `SecondaryButton` - Secondary action button
- `OutlineButton` - Outlined button
- `AppTextButton` - Text-only button
- `CustomIconButton` - Icon button
- `CircularIconButton` - Circular icon button

### 4. Cards

- `ProductCard` - Card for displaying products
- `InfoCard` - Information display card
- `CustomCard` - Generic customizable card

### 5. Common Widgets

- `AppAvatar` - User avatar widget
- `AvatarGroup` - Group of overlapping avatars
- `AppBadge` - Notification badge
- `StatusBadge` - Status indicator badge
- `AppChip` - Chip widget
- `FilterChip` - Selectable filter chip
- `ChipGroup` - Group of chips
- `AppDivider` - Horizontal/vertical divider
- `EmptyState` - Empty state placeholder
- `AppErrorWidget` - Error display widget
- `LoadingIndicator` - Circular loading indicator
- `LoadingOverlay` - Full-screen loading overlay
- `RatingWidget` - Star rating display/input
- `AppTag` - Tag/label widget
- `AppStepper` - Step progress indicator
- `StepItem` - Individual step item

### 6. Dialogs & Snackbars

- `AppDialogs` - Pre-configured dialogs (info, success, error, warning, confirmation)
- `AppSnackbars` - Pre-configured snackbars (info, success, error, warning)

### 7. Input Fields

- `AppTextField` - Standard text input field
- `PasswordTextField` - Password input with visibility toggle
- `ConfirmPasswordTextField` - Password confirmation field
- `MultilineTextField` - Multi-line text input
- `CommentTextField` - Comment input field

### 8. Pagination

- `PaginationControls` - Pagination navigation controls
- `PageSizeSelector` - Dropdown for selecting page size

## Example Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/widgets/widget.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Screen',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Use any widget without additional imports
              ProductCard(
                imageUrl: 'https://example.com/image.jpg',
                title: 'Product Name',
                price: '\$99.99',
                onTap: () {},
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: TextEditingController(),
                labelText: 'Enter your name',
              ),

              const SizedBox(height: 16),

              PrimaryButton(
                text: 'Submit',
                onPressed: () {
                  AppSnackbars.showSuccess(
                    context,
                    message: 'Success!',
                  );
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  AppAvatar(
                    imageUrl: 'https://example.com/avatar.jpg',
                    name: 'John Doe',
                  ),
                  const SizedBox(width: 8),
                  AppBadge(
                    count: 5,
                    child: const Icon(Icons.notifications),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              RatingWidget(
                rating: 4.5,
                onRatingChanged: (rating) {
                  print('New rating: $rating');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Benefits

✅ **Cleaner Code** - Single import instead of multiple imports  
✅ **Easier Maintenance** - Central location for all widget exports  
✅ **Better Developer Experience** - No need to remember individual file paths  
✅ **Auto-completion** - IDE shows all available widgets from one import  
✅ **Reduced Boilerplate** - Less import statements in your files

## Notes

### Naming Conflicts Resolution

Some widgets had naming conflicts where the same class existed in multiple files. These have been resolved using the `hide` directive:

- `LoadingOverlay` - Exported from `loading_overlay.dart`, hidden from `loading_indicator.dart`
- `ConfirmPasswordTextField` - Exported from `confirm_password_text_field.dart`, hidden from `password_text_field.dart`

This ensures you always get the correct, dedicated widget file.

## Adding New Widgets

When you create a new widget, add it to the export file:

1. Create your widget file in the appropriate category folder
2. Open `lib/shared/widgets/widget.dart`
3. Add the export statement in the relevant category section:

```dart
// If adding a new button
export './buttons/your_new_button.dart';

// If adding a new input field
export './inputs/your_new_input.dart';
```

4. Keep the file organized by categories for easy maintenance

## Related Documentation

- [Responsive Design Guide](./RESPONSIVE_DESIGN_GUIDE.md)
- [Quick Start - Responsive](./QUICK_START_RESPONSIVE.md)
- [Widget Documentation](./WIDGET_DOCUMENTATION.md)
