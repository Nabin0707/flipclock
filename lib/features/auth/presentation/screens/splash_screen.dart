import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_providers.dart';
import 'package:flutter_clean_architecture/router/navigation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a small delay to show the splash screen briefly
    Future.delayed(const Duration(seconds: 2), _checkAuthAndNavigate);
  }

  void _checkAuthAndNavigate() {
    if (!mounted) {
      return;
    }

    final authState = ref.read(authNotifierProvider);

    authState.maybeWhen(
      authenticated: (_) => NavigationService.goToHome(context),
      unauthenticated: () => NavigationService.goToLogin(context),
      orElse: () => NavigationService.goToLogin(
          context), // Default to login for loading/initial states
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
