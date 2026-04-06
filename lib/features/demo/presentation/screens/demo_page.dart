import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/theme_provider.dart';
import 'package:flutter_clean_architecture/features/demo/presentation/screens/templates_demo.dart';
import 'package:flutter_clean_architecture/features/demo/providers/search_provider.dart';
import 'package:flutter_clean_architecture/shared/widgets/app_bars/custom_app_bar.dart';
import 'package:flutter_clean_architecture/shared/widgets/bottom_sheets/modal_bottom_sheet.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/icon_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/outline_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/secondary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/text_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/cards/custom_card.dart';
import 'package:flutter_clean_architecture/shared/widgets/cards/info_card.dart';
import 'package:flutter_clean_architecture/shared/widgets/cards/product_card.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/app_drawer.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/app_fab.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/avatar.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/badge.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/chip.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/divider.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/empty_state.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/error_widget.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/loading_indicator.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/rating.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/section_header.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/tag.dart';
import 'package:flutter_clean_architecture/shared/widgets/common/timeline.dart';
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_dialogs.dart';
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_snackbars.dart';
import 'package:flutter_clean_architecture/shared/widgets/inputs/app_text_field.dart';
import 'package:flutter_clean_architecture/shared/widgets/inputs/multiline_text_field.dart';
import 'package:flutter_clean_architecture/shared/widgets/inputs/password_text_field.dart';
import 'package:flutter_clean_architecture/shared/widgets/pagination/pagination_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: Add more component examples and interactive demos
/// Demo page to showcase all reusable components
class DemoPage extends ConsumerStatefulWidget {
  const DemoPage({super.key});

  @override
  ConsumerState<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends ConsumerState<DemoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 9, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ThemeAppBar(
        title: 'Component Demo',
        onThemeToggle: () {
          ref.read(themeModeProvider.notifier).toggleTheme();
        },
      ),
      drawer: ProfileDrawer(
        userName: 'Demo User',
        userEmail: 'demo@example.com',
        userAvatarUrl: 'https://via.placeholder.com/150',
        menuItems: [
          DrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          DrawerItem(
            icon: Icons.widgets,
            title: 'Components',
            badge: '12',
            isSelected: true,
            onTap: () => Navigator.pop(context),
          ),
          DrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => Navigator.pop(context),
          ),
          DrawerItem.divider(),
          DrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
      floatingActionButton: SpeedDialFAB(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            icon: Icons.edit,
            label: 'Edit',
            onPressed: () => _showSnackbar('Edit tapped'),
          ),
          SpeedDialChild(
            icon: Icons.share,
            label: 'Share',
            onPressed: () => _showSnackbar('Share tapped'),
          ),
          SpeedDialChild(
            icon: Icons.delete,
            label: 'Delete',
            onPressed: () => _showSnackbar('Delete tapped'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar with debouncing
          Padding(
            padding: EdgeInsets.all(16.r),
            child: SearchTextField(
              hintText: 'Search components...',
              onChanged: (value) {
                ref.read(demoSearchProvider.notifier).updateSearch(value);
              },
            ),
          ),
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Buttons'),
                Tab(text: 'Inputs'),
                Tab(text: 'Cards'),
                Tab(text: 'Dialogs'),
                Tab(text: 'States'),
                Tab(text: 'Templates'),
                Tab(text: 'New Widgets'),
                Tab(text: 'Theme'),
                Tab(text: 'All'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildButtonsDemo(),
                _buildInputsDemo(),
                _buildCardsDemo(),
                _buildDialogsDemo(),
                _buildStatesDemo(),
                _buildTemplatesDemo(),
                _buildNewWidgetsDemo(),
                _buildThemeDemo(),
                _buildAllComponentsDemo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Primary Buttons'),
        PrimaryButton(
          text: 'Primary Button',
          onPressed: () => _showSnackbar('Primary button pressed'),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'With Icon',
          icon: Icons.favorite,
          onPressed: () => _showSnackbar('Icon button pressed'),
        ),
        const SizedBox(height: 12),
        const PrimaryButton(
          text: 'Disabled',
          onPressed: null,
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Loading',
          isLoading: true,
          onPressed: () {},
        ),
        const SizedBox(height: 24),
        _sectionTitle('Secondary Buttons'),
        SecondaryButton(
          text: 'Secondary Button',
          onPressed: () => _showSnackbar('Secondary button pressed'),
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          text: 'With Icon',
          icon: Icons.send,
          onPressed: () => _showSnackbar('Secondary with icon pressed'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Outline Buttons'),
        OutlineButton(
          text: 'Outline Button',
          onPressed: () => _showSnackbar('Outline button pressed'),
        ),
        const SizedBox(height: 12),
        OutlineButton(
          text: 'With Icon',
          icon: Icons.download,
          onPressed: () => _showSnackbar('Outline with icon pressed'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Text Buttons'),
        AppTextButton(
          text: 'Text Button',
          onPressed: () => _showSnackbar('Text button pressed'),
        ),
        const SizedBox(height: 12),
        AppTextButton(
          text: 'With Icon',
          icon: Icons.link,
          onPressed: () => _showSnackbar('Text button with icon pressed'),
        ),
        const SizedBox(height: 12),
        const AppTextButton(
          text: 'Disabled',
          onPressed: null,
        ),
        const SizedBox(height: 12),
        AppTextButton(
          text: 'Loading',
          isLoading: true,
          onPressed: () {},
        ),
        _sectionTitle('Icon Buttons'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIconButton(
              icon: Icons.favorite_border,
              onPressed: () => _showSnackbar('Heart pressed'),
              tooltip: 'Favorite',
            ),
            CustomIconButton(
              icon: Icons.share,
              onPressed: () => _showSnackbar('Share pressed'),
              tooltip: 'Share',
            ),
            CircularIconButton(
              icon: Icons.add,
              onPressed: () => _showSnackbar('Add pressed'),
              tooltip: 'Add',
            ),
            CircularIconButton(
              icon: Icons.edit,
              onPressed: () => _showSnackbar('Edit pressed'),
              tooltip: 'Edit',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputsDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Text Fields'),
        AppTextField(
          controller: _emailController,
          labelText: 'Name',
          hintText: 'Enter your name',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        EmailTextField(
          labelText: 'Email',
          hintText: 'Enter your email',
        ),
        const SizedBox(height: 16),
        PhoneTextField(
          labelText: 'Phone',
          hintText: 'Enter your phone number',
        ),
        const SizedBox(height: 16),
        SearchTextField(
          hintText: 'Search...',
          onChanged: (value) => debugPrint('Search: $value'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Password Fields'),
        PasswordTextField(
          controller: _passwordController,
          labelText: 'Password',
          showStrengthIndicator: true,
        ),
        const SizedBox(height: 16),
        ConfirmPasswordTextField(
          passwordController: _passwordController,
          labelText: 'Confirm Password',
        ),
        const SizedBox(height: 24),
        _sectionTitle('Multiline Fields'),
        MultilineTextField(
          labelText: 'Description',
          hintText: 'Enter description...',
          maxLines: 4,
          maxLength: 200,
        ),
        const SizedBox(height: 16),
        CommentTextField(
          hintText: 'Write a comment...',
          maxLength: 300,
        ),
      ],
    );
  }

  Widget _buildCardsDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Product Cards'),
        SizedBox(
          height: 320.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => SizedBox(
              width: 200.w,
              child: ProductCard(
                imageUrl: 'https://via.placeholder.com/300',
                title: 'Product ${index + 1}',
                subtitle: 'Category',
                price: '\$${(index + 1) * 10}.99',
                originalPrice: index == 0 ? '\$${(index + 1) * 15}.99' : null,
                badge: index == 0 ? 'SALE' : null,
                badgeColor: Colors.red,
                onTap: () => _showSnackbar('Product ${index + 1} tapped'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Info Cards'),
        InfoCard(
          title: 'Total Sales',
          value: '\$12,345',
          icon: Icons.trending_up,
          iconColor: Colors.green,
          subtitle: '+12% from last month',
          onTap: () => _showSnackbar('Sales card tapped'),
        ),
        const SizedBox(height: 12),
        InfoCard(
          title: 'Active Users',
          value: '1,234',
          icon: Icons.people_outline,
          iconColor: Colors.blue,
          onTap: () => _showSnackbar('Users card tapped'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Custom Cards'),
        HeaderCard(
          title: 'Card Title',
          subtitle: 'Card subtitle',
          leading: CircleAvatar(
            radius: 24.r,
            child: Icon(Icons.account_circle, size: 28.sp),
          ),
          content: const Text(
              'This is the card content area. You can put any widget here.'),
          actions: [
            TextButton(
              onPressed: () => _showSnackbar('Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _showSnackbar('Save'),
              child: const Text('Save'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ExpandableCard(
          title: 'Expandable Card',
          subtitle: 'Tap to expand',
          leading: const Icon(Icons.expand_more),
          content: const Text(
            'This is expandable content. It can contain any widget and will show/hide when the header is tapped.',
          ),
        ),
      ],
    );
  }

  Widget _buildDialogsDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Dialogs'),
        PrimaryButton(
          text: 'Show Info Dialog',
          icon: Icons.info_outline,
          onPressed: () {
            AppDialogs.showInfoDialog(
              context: context,
              title: 'Information',
              message: 'This is an informational message.',
            );
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Show Success Dialog',
          icon: Icons.check_circle_outline,
          onPressed: () {
            AppDialogs.showSuccessDialog(
              context: context,
              title: 'Success',
              message: 'Operation completed successfully!',
            );
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Show Error Dialog',
          icon: Icons.error_outline,
          onPressed: () {
            AppDialogs.showErrorDialog(
              context: context,
              title: 'Error',
              message: 'An error occurred during the operation.',
            );
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Show Warning Dialog',
          icon: Icons.warning_amber_outlined,
          onPressed: () {
            AppDialogs.showWarningDialog(
              context: context,
              title: 'Warning',
              message: 'Please review before proceeding.',
            );
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Show Confirm Dialog',
          icon: Icons.help_outline,
          onPressed: () async {
            final result = await AppDialogs.showConfirmDialog(
              context: context,
              title: 'Confirm Action',
              message: 'Are you sure you want to proceed?',
            );
            if (result == true && mounted) {
              _showSnackbar('Confirmed');
            }
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Show Delete Dialog',
          icon: Icons.delete_outline,
          onPressed: () async {
            final result = await AppDialogs.showDeleteConfirmDialog(
              context: context,
              message: 'This action cannot be undone.',
            );
            if (result == true && mounted) {
              _showSnackbar('Deleted');
            }
          },
        ),
        const SizedBox(height: 24),
        _sectionTitle('Snackbars'),
        OutlineButton(
          text: 'Show Info Snackbar',
          icon: Icons.info_outline,
          onPressed: () {
            AppSnackbars.showInfo(
              context: context,
              message: 'This is an info message',
            );
          },
        ),
        const SizedBox(height: 12),
        OutlineButton(
          text: 'Show Success Snackbar',
          icon: Icons.check_circle_outline,
          onPressed: () {
            AppSnackbars.showSuccess(
              context: context,
              message: 'Operation successful!',
            );
          },
        ),
        const SizedBox(height: 12),
        OutlineButton(
          text: 'Show Error Snackbar',
          icon: Icons.error_outline,
          onPressed: () {
            AppSnackbars.showError(
              context: context,
              message: 'An error occurred',
            );
          },
        ),
        const SizedBox(height: 12),
        OutlineButton(
          text: 'Show Warning Snackbar',
          icon: Icons.warning_amber_outlined,
          onPressed: () {
            AppSnackbars.showWarning(
              context: context,
              message: 'Warning: Please review',
            );
          },
        ),
        const SizedBox(height: 24),
        _sectionTitle('Bottom Sheets'),
        SecondaryButton(
          text: 'Show Modal Bottom Sheet',
          icon: Icons.upload,
          onPressed: () {
            showAppModalBottomSheet(
              context: context,
              child: AppModalBottomSheet(
                title: 'Modal Bottom Sheet',
                content: const Text('This is the bottom sheet content.'),
                actions: [
                  OutlineButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  PrimaryButton(
                    text: 'Save',
                    onPressed: () {
                      Navigator.pop(context);
                      _showSnackbar('Saved');
                    },
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          text: 'Show List Bottom Sheet',
          icon: Icons.list,
          onPressed: () {
            ListBottomSheet.show(
              context: context,
              title: 'Select Option',
              items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
              itemBuilder: (item) => ListTile(
                title: Text(item),
                leading: const Icon(Icons.check_circle_outline),
              ),
              onItemTap: (item) => _showSnackbar('Selected: $item'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatesDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Loading States'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const AppLoadingIndicator(message: 'Loading...'),
                const SizedBox(height: 24),
                const AppLinearProgress(value: 0.7),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SkeletonPlaceholder(
                          height: 20, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                    const SkeletonPlaceholder(width: 60, height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Empty States'),
        const EmptyState(
          message: 'No items found',
          subtitle: 'Try adding some items',
          icon: Icons.inbox_outlined,
        ),
        const SizedBox(height: 24),
        _sectionTitle('Error States'),
        AppErrorWidget(
          message: 'Something went wrong',
          subtitle: 'Please try again later',
          actionText: 'Retry',
          onAction: () => _showSnackbar('Retry clicked'),
        ),
      ],
    );
  }

  Widget _buildThemeDemo() {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Theme Mode'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Mode: ${themeMode.name.toUpperCase()}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlineButton(
                      text: 'Light',
                      icon: Icons.light_mode,
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).setLightTheme();
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlineButton(
                      text: 'Dark',
                      icon: Icons.dark_mode,
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).setDarkTheme();
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlineButton(
                      text: 'System',
                      icon: Icons.phone_android,
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).setSystemTheme();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Color Palette'),
        _colorSwatch(
            'Primary', theme.colorScheme.primary, theme.colorScheme.onPrimary),
        _colorSwatch('Secondary', theme.colorScheme.secondary,
            theme.colorScheme.onSecondary),
        _colorSwatch(
            'Surface', theme.colorScheme.surface, theme.colorScheme.onSurface),
        _colorSwatch(
            'Error', theme.colorScheme.error, theme.colorScheme.onError),
        const SizedBox(height: 24),
        _sectionTitle('Typography'),
        _typographySample('Display Large', theme.textTheme.displayLarge),
        _typographySample('Headline Large', theme.textTheme.headlineLarge),
        _typographySample('Title Large', theme.textTheme.titleLarge),
        _typographySample('Body Large', theme.textTheme.bodyLarge),
        _typographySample('Label Large', theme.textTheme.labelLarge),
      ],
    );
  }

  Widget _buildTemplatesDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Page Templates'),
        const Text(
          'Reusable page templates for common UI patterns. '
          'Tap any template to see it in action.',
        ),
        const SizedBox(height: 24),
        _componentCategory(
          'List Template',
          Icons.list,
          'Search, filter, pagination, pull-to-refresh',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TemplatesDemo()),
          ),
        ),
        _componentCategory(
          'Detail Template',
          Icons.description,
          'Structured detail view with actions',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TemplatesDemo()),
          ),
        ),
        _componentCategory(
          'Form Template',
          Icons.edit,
          'Dynamic form with validation',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TemplatesDemo()),
          ),
        ),
        _componentCategory(
          'Profile Template',
          Icons.person,
          'User profile with stats and actions',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TemplatesDemo()),
          ),
        ),
        _componentCategory(
          'Settings Template',
          Icons.settings,
          'Settings with multiple item types',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TemplatesDemo()),
          ),
        ),
      ],
    );
  }

  Widget _buildNewWidgetsDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('Avatars'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppAvatar(name: 'John Doe', size: 50.r),
            AppAvatar(
                name: 'Jane Smith',
                size: 50.r,
                showOnlineIndicator: true,
                isOnline: true),
            AppAvatar(name: 'Alex Johnson', size: 50.r, icon: Icons.business),
          ],
        ),
        const SizedBox(height: 24),
        _sectionTitle('Badges'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            AppBadge(
              count: 5,
              child: Icon(Icons.notifications, size: 32.r),
            ),
            AppBadge(
              count: 99,
              position: BadgePosition.topLeft,
              child: Icon(Icons.mail, size: 32.r),
            ),
            StatusBadge(status: BadgeStatus.online, size: 12.r),
            StatusBadge(status: BadgeStatus.busy, size: 12.r),
          ],
        ),
        const SizedBox(height: 24),
        _sectionTitle('Chips'),
        ChipGroup(
          labels: const ['All', 'Technology', 'Design', 'Business'],
          selectedLabels: const ['All'],
          multiSelect: false,
          onSelectionChanged: (selected) =>
              _showSnackbar('Selected: $selected'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Ratings'),
        const AppRating(rating: 4.5, allowHalfRating: true),
        const SizedBox(height: 12),
        const RatingWithCount(rating: 4.8, count: 1234),
        const SizedBox(height: 24),
        _sectionTitle('Tags'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            StatusTag(status: TagStatus.success, label: 'Success'),
            StatusTag(status: TagStatus.warning, label: 'Warning'),
            StatusTag(status: TagStatus.error, label: 'Error'),
            StatusTag(status: TagStatus.info, label: 'Info'),
            StatusTag(status: TagStatus.pending, label: 'Pending'),
          ],
        ),
        const SizedBox(height: 24),
        _sectionTitle('Dividers'),
        const AppDivider(label: 'OR'),
        const SizedBox(height: 12),
        const DashedDivider(),
        const SizedBox(height: 12),
        const SectionDivider(label: 'Section Title', icon: Icons.star),
        const SizedBox(height: 24),
        _sectionTitle('Timeline'),
        AppTimeline(
          items: [
            TimelineItem(
              content: const Text('Order placed'),
              icon: Icons.shopping_cart,
              indicatorColor: Colors.green,
            ),
            TimelineItem(
              content: const Text('Processing'),
              icon: Icons.settings,
              indicatorColor: Colors.blue,
            ),
            TimelineItem(
              content: const Text('Shipped'),
              icon: Icons.local_shipping,
              indicatorColor: Colors.grey,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _sectionTitle('Stepper'),
        AppStepper(
          currentStep: 1,
          steps: [
            StepItem(title: 'Cart', content: const Text('Review items')),
            StepItem(title: 'Payment', content: const Text('Enter payment')),
            StepItem(title: 'Done', content: const Text('Complete')),
          ],
          onStepTapped: (index) => _showSnackbar('Step $index tapped'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Pagination'),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PaginationInfo(
              currentPage: 2,
              totalPages: 10,
              totalItems: 200,
              itemsPerPage: 20,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PageNumberButtons(
              currentPage: 5,
              totalPages: 20,
              onPageChanged: (page) => _showSnackbar('Page $page'),
              maxVisiblePages: 5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        _sectionTitle('Section Headers'),
        SectionHeader(
          title: 'Basic Section',
          subtitle: 'With subtitle and action',
          trailing: TextButton(
            onPressed: () => _showSnackbar('View All'),
            child: const Text('View All'),
          ),
        ),
        SizedBox(height: 16.h),
        LargeSectionHeader(
          icon: Icons.star,
          title: 'Featured Section',
          subtitle: 'Large header with icon',
        ),
        SizedBox(height: 16.h),
        const DividerSectionHeader(
          title: 'Divider Section',
        ),
        const SizedBox(height: 24),
        _sectionTitle('Floating Action Buttons'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppFAB(
              icon: Icons.add,
              mini: true,
              onPressed: () => _showSnackbar('FAB pressed'),
            ),
            BadgedFAB(
              icon: Icons.message,
              badgeCount: 5,
              onPressed: () => _showSnackbar('Badged FAB pressed'),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Center(
          child: AppFAB(
            icon: Icons.edit,
            label: 'Edit',
            onPressed: () => _showSnackbar('Extended FAB pressed'),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.menu),
              label: const Text('Open Drawer'),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.info),
              label: const Text('Info'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Drawer Demo',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 12.h),
                        const Text(
                          'Click the menu icon above to open the navigation drawer. '
                          'The drawer includes a user profile header, navigation items with icons, '
                          'and optional badge indicators.',
                        ),
                        SizedBox(height: 24.h),
                        PrimaryButton(
                          text: 'Got it',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAllComponentsDemo() {
    final filteredComponents = ref.watch(filteredDemoComponentsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionTitle('All Components Overview'),
        const Text('This demo showcases the complete component library. '
            'Use the tabs above or search bar to explore components.'),
        const SizedBox(height: 24),
        if (filteredComponents.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No components found'),
            ),
          )
        else
          ...filteredComponents.map((component) {
            switch (component) {
              case 'Buttons':
                return _componentCategory('Buttons', Icons.smart_button,
                    'Primary, Secondary, Outline, Icon buttons');
              case 'Inputs':
                return _componentCategory('Inputs', Icons.input,
                    'Text fields, Password, Email, Phone, Search');
              case 'Cards':
                return _componentCategory('Cards', Icons.card_membership,
                    'Product, Info, Custom, Expandable cards');
              case 'Dialogs':
                return _componentCategory('Dialogs', Icons.chat_bubble_outline,
                    'Info, Success, Error, Confirm dialogs');
              case 'States':
                return _componentCategory(
                    'Loading & States',
                    Icons.hourglass_empty,
                    'Indicators, Progress bars, Empty states');
              case 'Templates':
                return _componentCategory(
                  'Page Templates',
                  Icons.web,
                  'List, Detail, Form, Profile, Settings',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TemplatesDemo()),
                  ),
                );
              case 'Avatar':
                return _componentCategory('Avatar', Icons.account_circle,
                    'User avatars, Groups, Online indicators');
              case 'Badge':
                return _componentCategory('Badge', Icons.notifications_active,
                    'Notification badges, Status badges');
              case 'Chip':
                return _componentCategory(
                    'Chip', Icons.label, 'Filter, Choice, Input chips');
              case 'Divider':
                return _componentCategory('Divider', Icons.horizontal_rule,
                    'Horizontal, Vertical, Dashed dividers');
              case 'Rating':
                return _componentCategory(
                    'Rating', Icons.star, 'Star ratings, Breakdowns, Counts');
              case 'Tag':
                return _componentCategory(
                    'Tag', Icons.local_offer, 'Status tags, Outlined tags');
              case 'Timeline':
                return _componentCategory('Timeline', Icons.timeline,
                    'Vertical timeline, Custom indicators');
              case 'Pagination':
                return _componentCategory(
                    'Pagination', Icons.pages, 'Load more, Page numbers, Info');
              default:
                return const SizedBox.shrink();
            }
          }).toList(),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _colorSwatch(String label, Color color, Color onColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: onColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.r,
          ),
        ),
      ),
    );
  }

  Widget _typographySample(String label, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text('The quick brown fox', style: style),
        ],
      ),
    );
  }

  Widget _componentCategory(String title, IconData icon, String description,
      {VoidCallback? onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32.r),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios, size: 16.r),
        onTap: onTap ?? () => _showSnackbar('$title components'),
      ),
    );
  }

  void _showSnackbar(String message) {
    AppSnackbars.showInfo(context: context, message: message);
  }
}
