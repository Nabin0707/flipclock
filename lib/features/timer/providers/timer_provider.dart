import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountdownTimerState {
  const CountdownTimerState({
    required this.total,
    required this.remaining,
    required this.isRunning,
    required this.isCompleted,
  });

  final Duration total;
  final Duration remaining;
  final bool isRunning;
  final bool isCompleted;

  static const CountdownTimerState initial = CountdownTimerState(
    total: Duration(minutes: 25),
    remaining: Duration(minutes: 25),
    isRunning: false,
    isCompleted: false,
  );

  CountdownTimerState copyWith({
    Duration? total,
    Duration? remaining,
    bool? isRunning,
    bool? isCompleted,
  }) {
    return CountdownTimerState(
      total: total ?? this.total,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final timerProvider =
    StateNotifierProvider<TimerNotifier, CountdownTimerState>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<CountdownTimerState> {
  TimerNotifier() : super(CountdownTimerState.initial);

  Timer? _ticker;

  void setDuration(Duration value) {
    if (value.inSeconds <= 0 || state.isRunning) {
      return;
    }
    state = state.copyWith(
      total: value,
      remaining: value,
      isCompleted: false,
    );
  }

  void start() {
    if (state.isRunning || state.remaining.inSeconds <= 0) {
      return;
    }

    _ticker?.cancel();
    state = state.copyWith(isRunning: true, isCompleted: false);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.remaining - const Duration(seconds: 1);
      if (next.inSeconds <= 0) {
        _ticker?.cancel();
        state = state.copyWith(
          remaining: Duration.zero,
          isRunning: false,
          isCompleted: true,
        );
        return;
      }
      state = state.copyWith(remaining: next);
    });
  }

  void pause() {
    _ticker?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _ticker?.cancel();
    state = state.copyWith(
      remaining: state.total,
      isRunning: false,
      isCompleted: false,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
