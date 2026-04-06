import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PomodoroPhase { work, shortBreak, longBreak }

class PomodoroSettings {
  final Duration workDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int sessionsBeforeLongBreak;

  const PomodoroSettings({
    this.workDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.sessionsBeforeLongBreak = 4,
  });
}

class PomodoroState {
  final PomodoroPhase phase;
  final Duration remaining;
  final Duration totalDuration;
  final int sessionCount;
  final bool isRunning;
  final bool isFinished;
  final PomodoroSettings settings;

  const PomodoroState({
    this.phase = PomodoroPhase.work,
    this.remaining = const Duration(minutes: 25),
    this.totalDuration = const Duration(minutes: 25),
    this.sessionCount = 0,
    this.isRunning = false,
    this.isFinished = false,
    this.settings = const PomodoroSettings(),
  });

  double get progress => totalDuration.inSeconds > 0
      ? 1 - (remaining.inSeconds / totalDuration.inSeconds)
      : 0;

  PomodoroState copyWith({
    PomodoroPhase? phase,
    Duration? remaining,
    Duration? totalDuration,
    int? sessionCount,
    bool? isRunning,
    bool? isFinished,
    PomodoroSettings? settings,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      remaining: remaining ?? this.remaining,
      totalDuration: totalDuration ?? this.totalDuration,
      sessionCount: sessionCount ?? this.sessionCount,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
      settings: settings ?? this.settings,
    );
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier() : super(const PomodoroState()) {
    _initState();
  }

  Timer? _timer;

  void _initState() {
    state = PomodoroState(
      remaining: state.settings.workDuration,
      totalDuration: state.settings.workDuration,
    );
  }

  void start() {
    if (state.isRunning) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newRemaining = state.remaining - const Duration(seconds: 1);
      if (newRemaining <= Duration.zero) {
        _timer?.cancel();
        _onPhaseComplete();
      } else {
        state = state.copyWith(remaining: newRemaining);
      }
    });
    state = state.copyWith(isRunning: true, isFinished: false);
  }

  void _onPhaseComplete() {
    final nextSessionCount = state.phase == PomodoroPhase.work
        ? state.sessionCount + 1
        : state.sessionCount;

    final PomodoroPhase nextPhase;
    if (state.phase == PomodoroPhase.work) {
      nextPhase =
          nextSessionCount % state.settings.sessionsBeforeLongBreak == 0
              ? PomodoroPhase.longBreak
              : PomodoroPhase.shortBreak;
    } else {
      nextPhase = PomodoroPhase.work;
    }

    final nextDuration = _durationForPhase(nextPhase);
    state = state.copyWith(
      phase: nextPhase,
      remaining: nextDuration,
      totalDuration: nextDuration,
      sessionCount: nextSessionCount,
      isRunning: false,
      isFinished: true,
    );
  }

  Duration _durationForPhase(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.work:
        return state.settings.workDuration;
      case PomodoroPhase.shortBreak:
        return state.settings.shortBreakDuration;
      case PomodoroPhase.longBreak:
        return state.settings.longBreakDuration;
    }
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void skip() {
    _timer?.cancel();
    _onPhaseComplete();
  }

  void reset() {
    _timer?.cancel();
    state = PomodoroState(
      remaining: state.settings.workDuration,
      totalDuration: state.settings.workDuration,
    );
  }

  void clearFinished() {
    state = state.copyWith(isFinished: false);
  }

  void updateSettings(PomodoroSettings settings) {
    _timer?.cancel();
    state = PomodoroState(
      settings: settings,
      remaining: settings.workDuration,
      totalDuration: settings.workDuration,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>(
  (ref) => PomodoroNotifier(),
);
