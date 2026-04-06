import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_providers.dart';
import 'package:flutter_clean_architecture/router/navigation_service.dart';
import 'package:flutter_clean_architecture/shared/widgets/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeToTerms) {
        AppSnackbars.showWarning(
          context: context,
          message: 'Please agree to the terms and conditions to continue.',
        );
        return;
      }

      await ref.read(authNotifierProvider.notifier).signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
          );
    }
  }

  void _showTermsDialog() {
    AppDialogs.showConfirmDialog(
      context: context,
      title: 'Terms & Conditions',
      message:
          'By creating an account, you agree to our Terms of Service and Privacy Policy. '
          'We collect and use your information to provide our services and improve your experience.',
      confirmText: 'I Agree',
      cancelText: 'Cancel',
      onConfirm: () {
        setState(() {
          _agreeToTerms = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) {
          AppSnackbars.showSuccess(
            context: context,
            message: 'Account created successfully! Welcome aboard!',
          );
          NavigationService.goToHome(context);
        },
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
        appBar: AppBar(
          title: const Text('Create Account'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const SizedBox(height: 32),
                  Text(
                    'Join Us',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your account to get started',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  AppTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  AppTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    textInputAction: TextInputAction.next,
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
                  const SizedBox(height: 16),

                  // Password Field
                  PasswordTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Create a strong password',
                    textInputAction: TextInputAction.next,
                    showStrengthIndicator: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return 'Password must contain at least one lowercase letter';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Password must contain at least one number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  ConfirmPasswordTextField(
                    controller: _confirmPasswordController,
                    passwordController: _passwordController,
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),

                  // Terms & Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showTermsDialog,
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Register Button
                  PrimaryButton(
                    text: 'Create Account',
                    onPressed: _handleSubmit,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      AppTextButton(
                        text: 'Sign In',
                        onPressed: () => NavigationService.goToLogin(context),
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
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or try signing in.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email format. Please enter a valid email address.';
      case 'network-error':
        return 'Network error. Please check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many registration attempts. Please try again later.';
      default:
        return 'Registration failed. Please try again.';
    }
  }
}
