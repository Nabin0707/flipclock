import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:go_router/go_router.dart';

abstract final class NavigationService {
  static void push(BuildContext context, String location, {Object? extra}) {
    context.push(location, extra: extra);
  }

  static void pushReplacement(BuildContext context, String location,
      {Object? extra}) {
    context.pushReplacement(location, extra: extra);
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    context.pop(result);
  }

  static void go(BuildContext context, String location, {Object? extra}) {
    context.go(location, extra: extra);
  }

  static void goToClock(BuildContext context) => go(context, Routes.clock);
  static void goToSettings(BuildContext context) =>
      go(context, Routes.settings);
  static void goToFocus(BuildContext context) => go(context, Routes.focus);
  static void goToFocusAnalytics(BuildContext context) =>
      go(context, Routes.focusAnalytics);
  static void goToTimer(BuildContext context) => go(context, Routes.timer);
  static void goToStopwatch(BuildContext context) =>
      go(context, Routes.stopwatch);
  static void goToPomodoro(BuildContext context) =>
      go(context, Routes.pomodoro);
}
