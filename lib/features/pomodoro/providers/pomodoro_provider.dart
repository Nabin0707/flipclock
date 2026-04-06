import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PomodoroState {
  const PomodoroState({
    required this.workDuration,
    required this.breakDuration,
    required this.remaining,
    required this.isWorkPhase,
    required this.isRunning,
    required this.completedWorkSessions,
  });

  final Duration workDuration;
  final Duration breakDuration;
  final Duration remaining;
  final bool isWorkPhase;
  final bool isRunning;
  final int completedWorkSessions;

  static const PomodoroState initial = PomodoroState(
    workDuration: Duration(minutes: 25),
    breakDuration: Duration(minutes: 5),
    remaining: Duration(minutes: 25),
    isWorkPhase: true,
    isRunning: false,
    completedWorkSessions: 0,
  );

  PomodoroState copyWith({
    Duration? workDuration,
    Duration? breakDuration,
    Duration? remaining,
    bool? isWorkPhase,
    bool? isRunning,
    int? completedWorkSessions,
  }) {
    return PomodoroState(
      workDuration: workDuration ?? this.workDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      remaining: remaining ?? this.remaining,
      isWorkPhase: isWorkPhase ?? this.isWorkPhase,
      isRunning: isRunning ?? this.isRunning,
      completedWorkSessions:
          completedWorkSessions ?? this.completedWorkSessions,
    );
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier();
});

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier() : super(PomodoroState.initial);

  Timer? _ticker;

  void setWorkMinutes(int minutes) {
    if (minutes < 1 || state.isRunning) {
      return;
    }
    final duration = Duration(minutes: minutes);
    state = state.copyWith(
      workDuration: duration,
      remaining: state.isWorkPhase ? duration : state.remaining,
    );
  }

  void setBreakMinutes(int minutes) {
    if (minutes < 1 || state.isRunning) {
      return;
    }
    final duration = Duration(minutes: minutes);
    state = state.copyWith(
      breakDuration: duration,
      remaining: state.isWorkPhase ? state.remaining : duration,
    );
  }

  void start() {
    if (state.isRunning) {
      return;
    }
    state = state.copyWith(isRunning: true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.remaining - const Duration(seconds: 1);
      if (next.inSeconds <= 0) {
        _switchPhase();
        return;
      }
      state = state.copyWith(remaining: next);
    });
  }

  void pause() {
    _ticker?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void skipPhase() {
    _switchPhase();
  }

  void reset() {
    _ticker?.cancel();
    state = PomodoroState.initial;
  }

  void _switchPhase() {
    final wasWork = state.isWorkPhase;
    final nextIsWork = !wasWork;
    state = state.copyWith(
      isWorkPhase: nextIsWork,
      remaining: nextIsWork ? state.workDuration : state.breakDuration,
      completedWorkSessions: wasWork
          ? state.completedWorkSessions + 1
          : state.completedWorkSessions,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
