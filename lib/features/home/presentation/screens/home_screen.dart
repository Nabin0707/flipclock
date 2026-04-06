import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_providers.dart';
import 'package:flutter_clean_architecture/router/navigation_service.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_dialogs.dart';
import 'package:flutter_clean_architecture/shared/widgets/dialogs/app_snackbars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppDialogs.showConfirmDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Listen to auth state changes
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        unauthenticated: () => NavigationService.goToLogin(context),
        error: (message) {
          AppSnackbars.showError(
            context: context,
            message: 'Logout failed: $message',
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context, ref),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome section
                    Icon(
                      Icons.home_outlined,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to Flutter Clean Architecture!',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'A comprehensive template with 40+ reusable components, theme system, and state management.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Demo page button
                    PrimaryButton(
                      text: 'Explore Component Demo',
                      icon: Icons.widgets_outlined,
                      onPressed: () => NavigationService.goToDemo(context),
                    ),
                    const SizedBox(height: 16),

                    // Additional info
                    Text(
                      'Discover all 40+ components, themes, and interactive examples',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
