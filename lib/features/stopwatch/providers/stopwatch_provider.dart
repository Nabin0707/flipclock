import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LapEntry {
  final int lapNumber;
  final Duration lapTime;
  final Duration totalTime;

  const LapEntry({
    required this.lapNumber,
    required this.lapTime,
    required this.totalTime,
  });
}

class StopwatchState {
  final Duration elapsed;
  final bool isRunning;
  final List<LapEntry> laps;
  final int bestLapIndex;
  final int worstLapIndex;

  const StopwatchState({
    this.elapsed = Duration.zero,
    this.isRunning = false,
    this.laps = const [],
    this.bestLapIndex = -1,
    this.worstLapIndex = -1,
  });

  StopwatchState copyWith({
    Duration? elapsed,
    bool? isRunning,
    List<LapEntry>? laps,
    int? bestLapIndex,
    int? worstLapIndex,
  }) {
    return StopwatchState(
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
      laps: laps ?? this.laps,
      bestLapIndex: bestLapIndex ?? this.bestLapIndex,
      worstLapIndex: worstLapIndex ?? this.worstLapIndex,
    );
  }
}

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  StopwatchNotifier() : super(const StopwatchState());

  Timer? _timer;
  DateTime? _startTime;
  Duration _accumulated = Duration.zero;

  void start() {
    if (state.isRunning) return;
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      final now = DateTime.now();
      final elapsed = _accumulated + now.difference(_startTime!);
      state = state.copyWith(elapsed: elapsed);
    });
    state = state.copyWith(isRunning: true);
  }

  void pause() {
    if (!state.isRunning) return;
    _timer?.cancel();
    _accumulated = state.elapsed;
    _startTime = null;
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    _accumulated = Duration.zero;
    _startTime = null;
    state = const StopwatchState();
  }

  void lap() {
    if (!state.isRunning) return;
    final total = state.elapsed;
    final previousTotal =
        state.laps.isEmpty ? Duration.zero : state.laps.last.totalTime;
    final lapTime = total - previousTotal;
    final newLap = LapEntry(
      lapNumber: state.laps.length + 1,
      lapTime: lapTime,
      totalTime: total,
    );
    final newLaps = [...state.laps, newLap];
    final (best, worst) = _calcBestWorst(newLaps);
    state = state.copyWith(
      laps: newLaps,
      bestLapIndex: best,
      worstLapIndex: worst,
    );
  }

  (int, int) _calcBestWorst(List<LapEntry> laps) {
    if (laps.isEmpty) return (-1, -1);
    int best = 0, worst = 0;
    for (int i = 1; i < laps.length; i++) {
      if (laps[i].lapTime < laps[best].lapTime) best = i;
      if (laps[i].lapTime > laps[worst].lapTime) worst = i;
    }
    return (best, worst);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final stopwatchProvider =
    StateNotifierProvider<StopwatchNotifier, StopwatchState>(
  (ref) => StopwatchNotifier(),
);
