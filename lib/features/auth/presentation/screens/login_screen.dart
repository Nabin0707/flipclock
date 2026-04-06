import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_providers.dart';
import 'package:flutter_clean_architecture/router/navigation_service.dart';
import 'package:flutter_clean_architecture/shared/widgets/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadCachedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCachedCredentials() async {
    final rememberMe = await ref.read(authRepositoryProvider).getRememberMe();
    if (rememberMe) {
      final credentials =
          await ref.read(authRepositoryProvider).getCachedCredentials();
      if (credentials != null) {
        setState(() {
          _emailController.text = credentials['email'] ?? '';
          _passwordController.text = credentials['password'] ?? '';
          _rememberMe = true;
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authNotifierProvider.notifier).signIn(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            rememberMe: _rememberMe,
          );
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    AppDialogs.showCustomDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and Title (following shared dialog pattern)
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32.r,
                ),
              ),
              SizedBox(height: 16.r),
              Text(
                'Reset Password',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16.r),

              // Content
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24.r),

              // Form
              Form(
                key: formKey,
                child: AppTextField(
                  controller: emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 24.r),

              // Actions (following shared dialog pattern)
              Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.r),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Send Reset Link',
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          _handleForgotPassword(emailController.text.trim());
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleForgotPassword(String email) {
    // TODO: Implement actual password reset functionality
    // For now, show a success message
    AppSnackbars.showSuccess(
      context: context,
      message:
          'If an account with $email exists, we\'ve sent you a password reset link.',
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) => NavigationService.goToHome(context),
        error: (message) {
          final String friendlyMessage = _getFriendlyErrorMessage(message);
          AppSnackbars.showError(
            context: context,
            message: friendlyMessage,
          );
        },
        orElse: () {},
      );
    });

    final isLoading = ref.watch(authNotifierProvider).maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  SizedBox(height: 32.r),
                  Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8.r),
                  Text(
                    'Enter your credentials to access your account',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                  SizedBox(height: 32.r),

                  // Email Field
                  AppTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.r),

                  // Password Field
                  PasswordTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.r),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      AppTextButton(
                        text: 'Forgot Password?',
                        onPressed: _showForgotPasswordDialog,
                      ),
                    ],
                  ),
                  SizedBox(height: 32.r),

                  // Login Button
                  PrimaryButton(
                    text: 'Sign In',
                    onPressed: _handleSubmit,
                    isLoading: isLoading,
                  ),
                  SizedBox(height: 16.r),

                  // Demo Credentials Info
                  CustomCard(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demo Credentials',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 8.r),
                        const Text('Admin: admin / admin'),
                        const Text('Test User: test@example.com / password123'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.r),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      AppTextButton(
                        text: 'Create Account',
                        onPressed: () =>
                            NavigationService.push(context, '/register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getFriendlyErrorMessage(String error) {
    switch (error) {
      case 'invalid-credentials':
        return 'Invalid email or password. Please check your credentials and try again.';
      case 'network-error':
        return 'Network error. Please check your internet connection and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
