import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_architecture/features/pomodoro/providers/pomodoro_provider.dart';
import 'package:flutter_clean_architecture/features/stopwatch/providers/stopwatch_provider.dart';
import 'package:flutter_clean_architecture/features/timer/providers/timer_provider.dart';

void main() {
  group('TimerNotifier', () {
    test('setDuration updates total and remaining', () {
      final notifier = TimerNotifier();

      notifier.setDuration(const Duration(minutes: 10));

      expect(notifier.state.total, const Duration(minutes: 10));
      expect(notifier.state.remaining, const Duration(minutes: 10));
      expect(notifier.state.isRunning, isFalse);
    });

    test('start and pause toggles running state', () {
      final notifier = TimerNotifier();

      notifier.start();
      expect(notifier.state.isRunning, isTrue);

      notifier.pause();
      expect(notifier.state.isRunning, isFalse);
    });
  });

  group('StopwatchNotifier', () {
    test('lap is recorded only while running', () {
      final notifier = StopwatchNotifier();

      notifier.lap();
      expect(notifier.state.laps, isEmpty);

      notifier.start();
      notifier.lap();
      notifier.pause();

      expect(notifier.state.laps.length, 1);
    });
  });

  group('PomodoroNotifier', () {
    test('skipPhase toggles work/break and tracks completed sessions', () {
      final notifier = PomodoroNotifier();

      expect(notifier.state.isWorkPhase, isTrue);
      expect(notifier.state.completedWorkSessions, 0);

      notifier.skipPhase();
      expect(notifier.state.isWorkPhase, isFalse);
      expect(notifier.state.completedWorkSessions, 1);

      notifier.skipPhase();
      expect(notifier.state.isWorkPhase, isTrue);
      expect(notifier.state.completedWorkSessions, 1);
    });
  });
}
