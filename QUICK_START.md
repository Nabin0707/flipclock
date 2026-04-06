# 🚀 Quick Start Guide

> Copy-paste ready examples for Flutter Clean Architecture components

---

## 📋 Table of Contents

- [Response Management](#-response-management)
- [Pagination](#-pagination)
- [Buttons](#-buttons)
- [Form Inputs](#-form-inputs)
- [Cards](#-cards)
- [Dialogs & Snackbars](#-dialogs--snackbars)
- [Loading States](#-loading-states)
- [Error & Empty States](#-error--empty-states)
- [New Display Components](#-new-display-components)
- [Page Templates](#-page-templates)
- [Theme System](#-theme-system)
- [Import Paths](#-import-paths)

---

## 📦 Response Management

### Basic API Response Handling

```dart
import 'package:flutter_clean_architecture/core/network/api_response.dart';

// In your API service
Future<ApiResponse<User>> getUser(String id) async {
  try {
    final response = await dio.get('/users/$id');
    return ApiResponse.success(
      data: User.fromJson(response.data),
      message: 'User loaded successfully',
    );
  } catch (e) {
    return ApiResponse.error(
      statusCode: 500,
      message: e.toString(),
    );
  }
}

// In your UI
final response = await api.getUser('123');
response.when(
  success: (user, message, meta) {
    // Handle success
    print('Got user: ${user.name}');
  },
  error: (code, message, errors) {
    // Handle error
    showSnackBar(message);
  },
);
```

### Result Pattern (Either)

```dart
import 'package:flutter_clean_architecture/core/network/failures.dart';
import 'package:dartz/dartz.dart';

// In your repository
Future<Result<User>> fetchUser(String id) async {
  try {
    final user = await dataSource.getUser(id);
    return Right(user);
  } on NetworkException {
    return Left(NetworkFailure.noInternet());
  } on ServerException catch (e) {
    return Left(ServerFailure.fromStatusCode(e.statusCode));
  } catch (e) {
    return Left(UnknownFailure(e.toString()));
  }
}

// In your UI/Use Case
final result = await repository.fetchUser('123');
result.fold(
  (failure) {
    // Handle failure
    if (failure is NetworkFailure) {
      showSnackBar('Check your internet connection');
    }
  },
  (user) {
    // Handle success
    setState(() => _user = user);
  },
);
```

### With Extension Methods

```dart
final result = await repository.fetchUser('123');

// Check success
if (result.isRight) {
  final user = result.getRight();
}

// Get or else
final user = result.getOrElse(() => User.empty());

// Map result
final userName = result.map((user) => user.name);
```

---

## 📄 Pagination

### Paginated Response Model

```dart
import 'package:flutter_clean_architecture/shared/models/pagination_models.dart';

// Parse API response
final response = PaginatedResponse<Product>.fromJson(
  jsonData,
  (json) => Product.fromJson(json),
);

// Access data
final products = response.data;
final currentPage = response.meta.currentPage;
final hasMore = response.meta.hasMore;
```

### Pagination State Management

```dart
class ProductsNotifier extends StateNotifier<PaginationState<Product>> {
  ProductsNotifier() : super(PaginationState.initial());

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);

    final result = await repository.getProducts(
      page: state.currentPage + 1,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: failure.message,
      ),
      (response) => state = state.copyWith(
        isLoading: false,
        items: [...state.items, ...response.data],
        currentPage: response.meta.currentPage,
        hasMore: response.meta.hasMore,
      ),
    );
  }
}
```

### Pagination Widgets

```dart
import 'package:flutter_clean_architecture/shared/widgets/pagination/pagination_widgets.dart';

// Load More Button
LoadMoreButton(
  isLoading: _isLoading,
  hasMore: _hasMore,
  onPressed: () => loadMore(),
)

// Page Numbers
PageNumberButtons(
  currentPage: _currentPage,
  totalPages: _totalPages,
  onPageChanged: (page) => loadPage(page),
  maxVisiblePages: 5,
)

// Pagination Info
PaginationInfo(
  currentPage: _currentPage,
  totalPages: _totalPages,
  totalItems: _totalItems,
  itemsPerPage: 20,
)
```

---

## 🎨 Buttons

### Primary Button

```dart
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';

PrimaryButton(
  text: 'Submit',
  onPressed: () => handleSubmit(),
  icon: Icons.check,
  isLoading: _isLoading,
)
```

### Secondary & Outline Buttons

```dart
import 'package:flutter_clean_architecture/shared/widgets/buttons/secondary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/outline_button.dart';

SecondaryButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
)

AppOutlineButton(
  text: 'Learn More',
  onPressed: () => showDetails(),
  icon: Icons.info,
)
```

### Icon Buttons

```dart
import 'package:flutter_clean_architecture/shared/widgets/buttons/icon_button.dart';

CustomIconButton(
  icon: Icons.favorite,
  onPressed: () => toggleFavorite(),
  backgroundColor: Colors.red,
  iconColor: Colors.white,
)

CircularIconButton(
  icon: Icons.add,
  onPressed: () => addItem(),
  size: 56,
)
```

---

## 📝 Form Inputs

### Standard Text Field

```dart
import 'package:flutter_clean_architecture/shared/widgets/inputs/app_text_field.dart';

AppTextField(
  controller: _nameController,
  label: 'Full Name',
  hint: 'Enter your name',
  icon: Icons.person,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)

// Email variant
EmailTextField(
  controller: _emailController,
  validator: (value) => isValidEmail(value) ? null : 'Invalid email',
)

// Phone variant
PhoneTextField(
  controller: _phoneController,
  onChanged: (value) => updatePhone(value),
)
```

### Password Field

```dart
import 'package:flutter_clean_architecture/shared/widgets/inputs/password_text_field.dart';

PasswordTextField(
  controller: _passwordController,
  showStrengthIndicator: true,
  validator: (value) => value!.length < 6 ? 'Too short' : null,
)

// Confirm password
ConfirmPasswordTextField(
  controller: _confirmController,
  passwordController: _passwordController,
)
```

### Multiline Text Field

```dart
import 'package:flutter_clean_architecture/shared/widgets/inputs/multiline_text_field.dart';

MultilineTextField(
  controller: _descriptionController,
  label: 'Description',
  minLines: 4,
  maxLines: 10,
)

// Comment variant
CommentTextField(
  controller: _commentController,
  hint: 'Write a comment...',
)
```

### Search Field

```dart
import 'package:flutter_clean_architecture/shared/widgets/inputs/app_text_field.dart';

SearchTextField(
  hintText: 'Search products...',
  onChanged: (query) => search(query),
  onClear: () => clearSearch(),
)
```

---

## 🎴 Cards

### Product Card

```dart
import 'package:flutter_clean_architecture/shared/widgets/cards/product_card.dart';

ProductCard(
  title: 'iPhone 15 Pro',
  price: '\$999',
  imageUrl: 'https://example.com/image.jpg',
  rating: 4.5,
  reviewCount: 1234,
  onTap: () => viewProduct(),
  onFavorite: () => toggleFavorite(),
)
```

### Info Card

```dart
import 'package:flutter_clean_architecture/shared/widgets/cards/info_card.dart';

InfoCard(
  title: 'Total Sales',
  value: '\$12,345',
  icon: Icons.trending_up,
  color: AppColors.success,
  onTap: () => viewDetails(),
)
```

### Custom Card

```dart
import 'package:flutter_clean_architecture/shared/widgets/cards/custom_card.dart';

CustomCard(
  child: Column(
    children: [
      Text('Your Content'),
      // ...
    ],
  ),
  padding: EdgeInsets.all(16),
  elevation: 2,
  onTap: () => handleTap(),
)
```

---

## 💬 Dialogs & Snackbars

### Show Dialogs

```dart
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_dialogs.dart';

// Success Dialog
AppDialogs.showSuccessDialog(
  context: context,
  title: 'Success!',
  message: 'Your data has been saved',
  onConfirm: () => Navigator.pop(context),
);

// Error Dialog
AppDialogs.showErrorDialog(
  context: context,
  title: 'Error',
  message: 'Failed to load data',
  onRetry: () => loadData(),
);

// Confirm Dialog
final confirmed = await AppDialogs.showConfirmDialog(
  context: context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
);

if (confirmed) {
  deleteItem();
}

// Warning Dialog
AppDialogs.showWarningDialog(
  context: context,
  title: 'Warning',
  message: 'This action cannot be undone',
);

// Info Dialog
AppDialogs.showInfoDialog(
  context: context,
  title: 'Information',
  message: 'New features available',
);
```

### Show Snackbars

```dart
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_snackbars.dart';

// Success
AppSnackbars.showSuccess(
  context: context,
  message: 'Item added to cart',
);

// Error
AppSnackbars.showError(
  context: context,
  message: 'Failed to process request',
);

// Warning
AppSnackbars.showWarning(
  context: context,
  message: 'Storage is almost full',
);

// Info
AppSnackbars.showInfo(
  context: context,
  message: 'New update available',
);

// With action
AppSnackbars.showSuccess(
  context: context,
  message: 'Item deleted',
  actionLabel: 'UNDO',
  onAction: () => undoDelete(),
);
```

---

## ⏳ Loading States

### Loading Indicator

```dart
import 'package:flutter_clean_architecture/shared/widgets/common/loading_indicator.dart';

// Simple spinner
AppLoadingIndicator()

// Large
AppLoadingIndicator.large()

// Custom color
AppLoadingIndicator(color: Colors.blue)
```

### Loading Overlay

```dart
LoadingOverlay(
  isLoading: _isLoading,
  child: YourContent(),
  opacity: 0.8,
)
```

### Shimmer Loading

```dart
ShimmerLoading(
  width: 200,
  height: 100,
  borderRadius: 12,
)
```

### Skeleton Loader

```dart
SkeletonLoader(
  child: Column(
    children: [
      SkeletonLine(width: 200),
      SizedBox(height: 8),
      SkeletonLine(width: 150),
    ],
  ),
)
```

### Progress Indicator

```dart
AppProgressIndicator(
  value: 0.75, // 75%
  label: 'Uploading...',
)
```

---

## 🚫 Error & Empty States

### Empty State

```dart
import 'package:flutter_clean_architecture/shared/widgets/common/empty_state.dart';

EmptyState(
  icon: Icons.inbox,
  message: 'No messages yet',
  subtitle: 'Start a conversation',
  actionLabel: 'New Message',
  onAction: () => createMessage(),
)

// Predefined variants
EmptyState.search(query: 'iPhone')
EmptyState.noData()
EmptyState.noInternet(onRetry: () => loadData())
```

### Error Widget

```dart
import 'package:flutter_clean_architecture/shared/widgets/common/error_widget.dart';

AppErrorWidget(
  message: 'Failed to load data',
  onRetry: () => loadData(),
)

// Network error
NetworkErrorWidget(
  onRetry: () => loadData(),
)

// Server error
ServerErrorWidget(
  statusCode: 500,
  onRetry: () => loadData(),
)
```

---

## 🎯 New Display Components

### Avatar

```dart
import 'package:flutter_clean_architecture/shared/widgets/avatar/avatar.dart';

// With image
AppAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  name: 'John Doe',
  size: 48,
)

// With initials
AppAvatar(
  name: 'John Doe',
  size: 48,
  showOnlineIndicator: true,
  isOnline: true,
)

// Avatar Group
AvatarGroup(
  imageUrls: ['url1', 'url2', 'url3', 'url4'],
  names: ['User 1', 'User 2', 'User 3', 'User 4'],
  maxVisible: 3,
  size: 40,
)
```

### Badge

```dart
import 'package:flutter_clean_architecture/shared/widgets/badges/badge.dart';

// Notification badge
AppBadge(
  count: 5,
  child: Icon(Icons.notifications),
)

// Position control
AppBadge(
  count: 99,
  position: BadgePosition.topLeft,
  child: Icon(Icons.mail),
)

// Status badge
StatusBadge(
  status: BadgeStatus.online,
  size: 12,
)
```

### Chips

```dart
import 'package:flutter_clean_architecture/shared/widgets/chips/chip.dart';

// Filter chip
FilterChip(
  label: 'Technology',
  isSelected: _isSelected,
  onSelected: (selected) => setState(() => _isSelected = selected),
)

// Chip Group
ChipGroup(
  labels: ['All', 'Technology', 'Design', 'Business'],
  selectedLabels: ['All'],
  multiSelect: false,
  onSelectionChanged: (selected) => filterByCategory(selected),
)
```

### Dividers

```dart
import 'package:flutter_clean_architecture/shared/widgets/dividers/divider.dart';

// With label
AppDivider(label: 'OR')

// Dashed
DashedDivider()

// Section divider
SectionDivider(
  label: 'Personal Information',
  icon: Icons.person,
)
```

### Rating

```dart
import 'package:flutter_clean_architecture/shared/widgets/rating/rating.dart';

// Star rating
AppRating(
  rating: 4.5,
  allowHalfRating: true,
  size: 24,
)

// With count
RatingWithCount(
  rating: 4.8,
  count: 1234,
)

// Interactive
RatingBar(
  initialRating: 3,
  onRatingChanged: (rating) => submitRating(rating),
)
```

### Tags

```dart
import 'package:flutter_clean_architecture/shared/widgets/tags/tag.dart';

// Status tag
StatusTag(
  status: TagStatus.success,
  label: 'Completed',
)

StatusTag(
  status: TagStatus.warning,
  label: 'Pending',
)

StatusTag(
  status: TagStatus.error,
  label: 'Failed',
)

// Custom tag
CustomTag(
  label: 'New',
  color: Colors.blue,
  icon: Icons.star,
)
```

### Timeline

```dart
import 'package:flutter_clean_architecture/shared/widgets/timeline/timeline.dart';

AppTimeline(
  items: [
    TimelineItem(
      content: Text('Order placed'),
      icon: Icons.shopping_cart,
      indicatorColor: Colors.green,
    ),
    TimelineItem(
      content: Text('Processing'),
      icon: Icons.settings,
      indicatorColor: Colors.blue,
    ),
    TimelineItem(
      content: Text('Shipped'),
      icon: Icons.local_shipping,
      indicatorColor: Colors.grey,
    ),
  ],
)
```

### Stepper

```dart
import 'package:flutter_clean_architecture/shared/widgets/stepper/stepper.dart';

AppStepper(
  currentStep: 1,
  steps: [
    StepItem(
      title: 'Cart',
      content: Text('Review your items'),
    ),
    StepItem(
      title: 'Payment',
      content: Text('Enter payment details'),
    ),
    StepItem(
      title: 'Confirm',
      content: Text('Confirm your order'),
    ),
  ],
  onStepTapped: (index) => goToStep(index),
  onStepContinue: () => nextStep(),
  onStepCancel: () => previousStep(),
)
```

---

## 📄 Page Templates

### List Page Template

```dart
import 'package:flutter_clean_architecture/shared/templates/list_page_template.dart';

ListPageTemplate<Product>(
  title: 'Products',
  onLoadItems: (page, search) async {
    final products = await api.getProducts(page: page, search: search);
    return products;
  },
  itemBuilder: (product) => ListTile(
    title: Text(product.name),
    subtitle: Text(product.price),
    onTap: () => viewProduct(product),
  ),
  showSearch: true,
  enablePagination: true,
  onAddPressed: () => createProduct(),
)
```

### Detail Page Template

```dart
import 'package:flutter_clean_architecture/shared/templates/detail_page_template.dart';

DetailPageTemplate<Product>(
  title: 'Product Details',
  onLoadData: () async => await api.getProduct(id),
  contentBuilder: (product) => Column(
    children: [
      DetailSection(
        title: 'Information',
        icon: Icons.info,
        child: Column(
          children: [
            DetailInfoRow(label: 'Name', value: product.name),
            DetailInfoRow(label: 'Price', value: product.price),
          ],
        ),
      ),
    ],
  ),
  actionsBuilder: (product) => [
    IconButton(icon: Icon(Icons.edit), onPressed: () => edit(product)),
    IconButton(icon: Icon(Icons.delete), onPressed: () => delete(product)),
  ],
  bottomBar: DetailActionsBar(
    primaryLabel: 'Buy Now',
    onPrimaryAction: () => purchase(product),
  ),
)
```

### Form Page Template

```dart
import 'package:flutter_clean_architecture/shared/templates/form_page_template.dart';

FormPageTemplate(
  title: 'Create Product',
  fields: [
    FormFieldConfig(
      key: 'name',
      label: 'Product Name',
      icon: Icons.shopping_bag,
      required: true,
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    ),
    FormFieldConfig(
      key: 'price',
      label: 'Price',
      icon: Icons.attach_money,
      keyboardType: TextInputType.number,
      required: true,
    ),
  ],
  onSubmit: (data) async {
    await api.createProduct(data);
    Navigator.pop(context);
  },
)
```

### Profile Page Template

```dart
import 'package:flutter_clean_architecture/shared/templates/profile_page_template.dart';

ProfilePageTemplate(
  name: 'John Doe',
  subtitle: 'Software Developer',
  imageUrl: user.avatarUrl,
  stats: [
    ProfileStat(label: 'Posts', value: '142'),
    ProfileStat(label: 'Followers', value: '1.2K'),
    ProfileStat(label: 'Following', value: '453'),
  ],
  actions: [
    ProfileAction(
      label: 'Message',
      icon: Icons.message,
      onTap: () => sendMessage(),
    ),
  ],
  infoItems: [
    ProfileInfoItem(
      label: 'Email',
      value: user.email,
      icon: Icons.email,
    ),
  ],
  onEditProfile: () => editProfile(),
)
```

### Settings Page Template

```dart
import 'package:flutter_clean_architecture/shared/templates/settings_page_template.dart';

SettingsPageTemplate(
  title: 'Settings',
  sections: [
    SettingsSection(
      title: 'Account',
      items: [
        SettingsItem.navigation(
          title: 'Profile',
          subtitle: 'Manage your profile',
          icon: Icons.person,
          onTap: () => goToProfile(),
        ),
      ],
    ),
    SettingsSection(
      title: 'Preferences',
      items: [
        SettingsItem.toggle(
          title: 'Notifications',
          icon: Icons.notifications,
          value: _notificationsEnabled,
          onChanged: (value) => toggleNotifications(value),
        ),
      ],
    ),
  ],
)
```

---

## 🎨 Theme System

### Use Theme Colors

```dart
import 'package:flutter_clean_architecture/core/theme/app_colors.dart';

Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.onPrimary),
  ),
)

// Status colors
Icon(Icons.check, color: AppColors.success)
Icon(Icons.warning, color: AppColors.warning)
Icon(Icons.error, color: AppColors.error)
```

### Toggle Theme

```dart
import 'package:flutter_clean_architecture/core/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// In a ConsumerWidget
Consumer(
  builder: (context, ref, child) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
    );
  },
)
```

### Custom Text Styles

```dart
import 'package:flutter_clean_architecture/core/theme/app_text_styles.dart';

Text('Headline', style: AppTextStyles.headlineLarge)
Text('Title', style: AppTextStyles.titleMedium)
Text('Body', style: AppTextStyles.bodyLarge)
Text('Label', style: AppTextStyles.labelSmall)
```

---

## 📚 Import Paths

### Core

```dart
// Theme
import 'package:flutter_clean_architecture/core/theme/app_colors.dart';
import 'package:flutter_clean_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture/core/providers/theme_provider.dart';

// Network
import 'package:flutter_clean_architecture/core/network/api_response.dart';
import 'package:flutter_clean_architecture/core/network/failures.dart';
```

### Models

```dart
import 'package:flutter_clean_architecture/shared/models/pagination_models.dart';
```

### Widgets

```dart
// Buttons
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/secondary_button.dart';

// Inputs
import 'package:flutter_clean_architecture/shared/widgets/inputs/app_text_field.dart';
import 'package:flutter_clean_architecture/shared/widgets/inputs/password_text_field.dart';

// Cards
import 'package:flutter_clean_architecture/shared/widgets/cards/product_card.dart';
import 'package:flutter_clean_architecture/shared/widgets/cards/info_card.dart';

// Dialogs
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_dialogs.dart';
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_snackbars.dart';

// Common
import 'package:flutter_clean_architecture/shared/widgets/common/loading_indicator.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/empty_state.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/error_widget.dart';

// New Components
import 'package:flutter_clean_architecture/shared/widgets/avatar/avatar.dart';
import 'package:flutter_clean_architecture/shared/widgets/badges/badge.dart';
import 'package:flutter_clean_architecture/shared/widgets/chips/chip.dart';
import 'package:flutter_clean_architecture/shared/widgets/dividers/divider.dart';
import 'package:flutter_clean_architecture/shared/widgets/rating/rating.dart';
import 'package:flutter_clean_architecture/shared/widgets/tags/tag.dart';
import 'package:flutter_clean_architecture/shared/widgets/timeline/timeline.dart';
import 'package:flutter_clean_architecture/shared/widgets/stepper/stepper.dart';
import 'package:flutter_clean_architecture/shared/widgets/pagination/pagination_widgets.dart';
```

### Templates

```dart
import 'package:flutter_clean_architecture/shared/templates/list_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/detail_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/form_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/profile_page_template.dart';
import 'package:flutter_clean_architecture/shared/templates/settings_page_template.dart';
```

---

## ✅ Component Checklist

### Buttons

- [x] Primary Button
- [x] Secondary Button
- [x] Outline Button
- [x] Icon Button
- [x] Circular Icon Button

### Inputs

- [x] Text Field (Email, Phone, Search variants)
- [x] Password Field (with strength indicator)
- [x] Confirm Password Field
- [x] Multiline Field (Comment, Description variants)

### Cards

- [x] Product Card
- [x] Info Card
- [x] Custom Card
- [x] Expandable Card
- [x] Header Card

### Dialogs & Snackbars

- [x] Success Dialog/Snackbar
- [x] Error Dialog/Snackbar
- [x] Warning Dialog/Snackbar
- [x] Info Dialog/Snackbar
- [x] Confirm Dialog

### Loading States

- [x] Loading Indicator
- [x] Loading Overlay
- [x] Shimmer Loading
- [x] Skeleton Loader
- [x] Progress Indicator

### Empty & Error States

- [x] Empty State (Generic, Search, NoData, NoInternet)
- [x] Error Widget (Network, Server, Generic)

### New Components

- [x] Avatar (Single, Group, Online indicator)
- [x] Badge (Count, Status)
- [x] Chip (Filter, Choice, Input, Action, Group)
- [x] Divider (Standard, Dashed, Section)
- [x] Rating (Display, Interactive, With count)
- [x] Tag (Status, Custom)
- [x] Timeline (Vertical, Horizontal)
- [x] Stepper (Multi-step)
- [x] Pagination (Load more, Page numbers, Info)

### Templates

- [x] List Page Template
- [x] Detail Page Template
- [x] Form Page Template
- [x] Profile Page Template
- [x] Settings Page Template

---

## 💡 Pro Tips

1. **Always use theme colors** instead of hardcoded colors
2. **Test both light and dark themes** for your components
3. **Add loading states** to all async operations
4. **Use ConsumerWidget** for widgets that need Riverpod state
5. **Follow Material Design 3** guidelines for consistency
6. **Add validation** to all form inputs
7. **Handle empty states** gracefully in lists
8. **Show errors** with retry options when API calls fail
9. **Use templates** as starting points for common page patterns
10. **Check the demo page** (`/demo` route) for live examples

---

## 🚀 Next Steps

1. **Explore the Demo Page**: Run the app and navigate to `/demo` to see all components in action
2. **Copy Examples**: Use the code snippets above as starting points
3. **Customize**: Modify components to match your design requirements
4. **Build Features**: Create new features using the provided architecture
5. **Test**: Add unit and widget tests for your components
6. **Document**: Add TODO comments for future enhancements

---

**Need more details?** Check [COMPONENTS_DOCUMENTATION.md](./COMPONENTS_DOCUMENTATION.md) for comprehensive documentation.

**Want to see the full change history?** Check [CHANGELOG.md](./CHANGELOG.md).
