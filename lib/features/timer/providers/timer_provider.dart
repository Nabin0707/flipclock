import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerState {
  final Duration remaining;
  final Duration totalDuration;
  final bool isRunning;
  final bool isFinished;
  final bool loopMode;

  const TimerState({
    this.remaining = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isRunning = false,
    this.isFinished = false,
    this.loopMode = false,
  });

  TimerState copyWith({
    Duration? remaining,
    Duration? totalDuration,
    bool? isRunning,
    bool? isFinished,
    bool? loopMode,
  }) {
    return TimerState(
      remaining: remaining ?? this.remaining,
      totalDuration: totalDuration ?? this.totalDuration,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
      loopMode: loopMode ?? this.loopMode,
    );
  }

  double get progress => totalDuration.inMilliseconds > 0
      ? 1 - (remaining.inMilliseconds / totalDuration.inMilliseconds)
      : 0;
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(const TimerState());

  Timer? _timer;
  bool _disposed = false;

  void setDuration(Duration duration) {
    _timer?.cancel();
    state = TimerState(
      remaining: duration,
      totalDuration: duration,
      loopMode: state.loopMode,
    );
  }

  void start() {
    if (state.isRunning || state.remaining == Duration.zero) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newRemaining = state.remaining - const Duration(seconds: 1);
      if (newRemaining <= Duration.zero) {
        _timer?.cancel();
        if (state.loopMode) {
          state = state.copyWith(
            remaining: state.totalDuration,
            isRunning: false,
            isFinished: true,
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!_disposed) {
              state = state.copyWith(isFinished: false);
              start();
            }
          });
        } else {
          state = state.copyWith(
            remaining: Duration.zero,
            isRunning: false,
            isFinished: true,
          );
        }
      } else {
        state = state.copyWith(remaining: newRemaining);
      }
    });
    state = state.copyWith(isRunning: true, isFinished: false);
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = TimerState(
      remaining: state.totalDuration,
      totalDuration: state.totalDuration,
      loopMode: state.loopMode,
    );
  }

  void toggleLoop() {
    state = state.copyWith(loopMode: !state.loopMode);
  }

  void clearFinished() {
    state = state.copyWith(isFinished: false);
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider =
    StateNotifierProvider<TimerNotifier, TimerState>(
  (ref) => TimerNotifier(),
);
