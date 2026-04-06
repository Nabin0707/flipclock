import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/theme_provider.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_providers.dart';
import 'package:flutter_clean_architecture/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Add any global initialization logic here (e.g., Firebase, Hive, etc.)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences for auth providers
  final sharedPreferences = await SharedPreferences.getInstance();

  // Wrap app with ProviderScope for Riverpod state management
  runApp(ProviderScope(
    overrides: [
      // Override the sharedPreferencesProvider with actual instance
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
    child: const MyApp(),
  ));
}

/// Root widget with Riverpod Consumer for theme management
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme mode changes from provider
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      // Design size from your design (adjust to your design dimensions)
      designSize: const Size(375, 812), // iPhone 11 Pro size as baseline
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Flutter Clean Architecture',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode, // Dynamic theme switching
        );
      },
    );
  }
}
