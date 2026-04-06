import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StopwatchState {
  const StopwatchState({
    required this.isRunning,
    required this.elapsed,
    required this.laps,
  });

  final bool isRunning;
  final Duration elapsed;
  final List<Duration> laps;

  static const StopwatchState initial = StopwatchState(
    isRunning: false,
    elapsed: Duration.zero,
    laps: [],
  );

  StopwatchState copyWith({
    bool? isRunning,
    Duration? elapsed,
    List<Duration>? laps,
  }) {
    return StopwatchState(
      isRunning: isRunning ?? this.isRunning,
      elapsed: elapsed ?? this.elapsed,
      laps: laps ?? this.laps,
    );
  }
}

final stopwatchProvider =
    StateNotifierProvider<StopwatchNotifier, StopwatchState>((ref) {
  return StopwatchNotifier();
});

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  StopwatchNotifier() : super(StopwatchState.initial);

  Timer? _ticker;

  void start() {
    if (state.isRunning) {
      return;
    }
    state = state.copyWith(isRunning: true);
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      state = state.copyWith(
        elapsed: state.elapsed + const Duration(milliseconds: 100),
      );
    });
  }

  void pause() {
    _ticker?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void lap() {
    if (!state.isRunning) {
      return;
    }
    state = state.copyWith(laps: [state.elapsed, ...state.laps]);
  }

  void reset() {
    _ticker?.cancel();
    state = StopwatchState.initial;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
