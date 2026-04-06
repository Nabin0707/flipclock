import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_clean_architecture/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_clean_architecture/features/clock/presentation/clock_screen.dart';
import 'package:flutter_clean_architecture/features/demo/presentation/screens/demo_page.dart';
import 'package:flutter_clean_architecture/features/flipclock/presentation/flipclock_shell.dart';
import 'package:flutter_clean_architecture/features/focus/presentation/focus_screen.dart';
import 'package:flutter_clean_architecture/features/home/presentation/layout/home_layout.dart';
import 'package:flutter_clean_architecture/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_clean_architecture/features/pomodoro/presentation/pomodoro_screen.dart';
import 'package:flutter_clean_architecture/features/settings/presentation/settings_screen.dart';
import 'package:flutter_clean_architecture/features/stopwatch/presentation/stopwatch_screen.dart';
import 'package:flutter_clean_architecture/features/timer/presentation/timer_screen.dart';
import 'package:flutter_clean_architecture/router/guards.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorClockKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellClock');
  static final _shellNavigatorStopwatchKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellStopwatch');
  static final _shellNavigatorTimerKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellTimer');
  static final _shellNavigatorPomodoroKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellPomodoro');
  static final _shellNavigatorFocusKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellFocus');

  static GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: Routes.clock,
        redirect: AuthGuard.guard,
        routes: [
          GoRoute(
            path: Routes.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: Routes.login,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: Routes.register,
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: Routes.demo,
            builder: (context, state) => const DemoPage(),
          ),
          GoRoute(
            path: Routes.settings,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const SettingsScreen(),
          ),
          ShellRoute(
            builder: (context, state, child) => HomeLayout(child: child),
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                FlipClockShell(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                navigatorKey: _shellNavigatorClockKey,
                routes: [
                  GoRoute(
                    path: Routes.clock,
                    builder: (context, state) => const ClockScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: _shellNavigatorStopwatchKey,
                routes: [
                  GoRoute(
                    path: Routes.stopwatch,
                    builder: (context, state) => const StopwatchScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: _shellNavigatorTimerKey,
                routes: [
                  GoRoute(
                    path: Routes.timer,
                    builder: (context, state) => const TimerScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: _shellNavigatorPomodoroKey,
                routes: [
                  GoRoute(
                    path: Routes.pomodoro,
                    builder: (context, state) => const PomodoroScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: _shellNavigatorFocusKey,
                routes: [
                  GoRoute(
                    path: Routes.focus,
                    builder: (context, state) => const FocusScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
