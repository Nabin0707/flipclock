import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/clock/presentation/clock_screen.dart';
import 'package:flutter_clean_architecture/features/focus/presentation/focus_screen.dart';
import 'package:flutter_clean_architecture/features/pomodoro/presentation/pomodoro_screen.dart';
import 'package:flutter_clean_architecture/features/settings/presentation/settings_screen.dart';
import 'package:flutter_clean_architecture/features/stopwatch/presentation/stopwatch_screen.dart';
import 'package:flutter_clean_architecture/features/timer/presentation/timer_screen.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: Routes.clock,
        routes: [
          GoRoute(
            path: Routes.clock,
            builder: (context, state) => const ClockScreen(),
          ),
          GoRoute(
            path: Routes.settings,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: Routes.focus,
            builder: (context, state) => const FocusScreen(),
          ),
          GoRoute(
            path: Routes.timer,
            builder: (context, state) => const TimerScreen(),
          ),
          GoRoute(
            path: Routes.stopwatch,
            builder: (context, state) => const StopwatchScreen(),
          ),
          GoRoute(
            path: Routes.pomodoro,
            builder: (context, state) => const PomodoroScreen(),
          ),
        ],
      );
}
