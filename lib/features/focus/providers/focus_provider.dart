import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clean_architecture/core/providers/shared_preferences_provider.dart';
import 'package:flutter_clean_architecture/features/focus/domain/focus_models.dart';

const _kFocusSessionsKey = 'focus_sessions_v1';
const _kFocusCategoriesKey = 'focus_categories_v1';
const _kDefaultCategories = <String>[
  'Study',
  'Coding',
  'Reading',
  'Workout',
  'Gaming',
  'Meditation',
];

final focusSessionsProvider =
    StateNotifierProvider<FocusSessionsNotifier, List<FocusSession>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FocusSessionsNotifier(prefs.getString(_kFocusSessionsKey), (value) {
    return prefs.setString(_kFocusSessionsKey, value);
  });
});

final focusCategoriesProvider =
    StateNotifierProvider<FocusCategoriesNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FocusCategoriesNotifier(prefs.getString(_kFocusCategoriesKey),
      (value) => prefs.setString(_kFocusCategoriesKey, value));
});

final focusTimerProvider =
    StateNotifierProvider<FocusTimerNotifier, FocusTimerState>((ref) {
  return FocusTimerNotifier();
});

final focusAnalyticsProvider = Provider<FocusAnalytics>((ref) {
  final sessions = ref.watch(focusSessionsProvider);
  return calculateFocusAnalytics(sessions, now: DateTime.now());
});

FocusAnalytics calculateFocusAnalytics(
  List<FocusSession> sessions, {
  required DateTime now,
}) {
  if (sessions.isEmpty) {
    return FocusAnalytics.empty;
  }

  final startOfToday = DateTime(now.year, now.month, now.day);
  final startOfWeek = startOfToday.subtract(Duration(days: now.weekday - 1));
  final startOfMonth = DateTime(now.year, now.month, 1);
  final startOfYear = DateTime(now.year, 1, 1);

  Duration today = Duration.zero;
  Duration week = Duration.zero;
  Duration month = Duration.zero;
  Duration year = Duration.zero;
  Duration total = Duration.zero;
  final categoryMap = <String, Duration>{};

  for (final session in sessions) {
    final duration = session.duration;
    total += duration;

    categoryMap[session.category] =
        (categoryMap[session.category] ?? Duration.zero) + duration;

    if (!session.endedAt.isBefore(startOfToday)) {
      today += duration;
    }
    if (!session.endedAt.isBefore(startOfWeek)) {
      week += duration;
    }
    if (!session.endedAt.isBefore(startOfMonth)) {
      month += duration;
    }
    if (!session.endedAt.isBefore(startOfYear)) {
      year += duration;
    }
  }

  final todayPercent = (today.inMinutes / (24 * 60)) * 100;
  final weeklyAverage = Duration(minutes: (week.inMinutes / 7).round());
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final monthlyAverage =
      Duration(minutes: (month.inMinutes / daysInMonth).round());

  return FocusAnalytics(
    today: today,
    thisWeek: week,
    thisMonth: month,
    thisYear: year,
    total: total,
    todayPercent: todayPercent.clamp(0, 100),
    weeklyAverage: weeklyAverage,
    monthlyAverage: monthlyAverage,
    categoryBreakdown: Map<String, Duration>.unmodifiable(categoryMap),
  );
}

class FocusSessionsNotifier extends StateNotifier<List<FocusSession>> {
  FocusSessionsNotifier(
    String? raw,
    this._save,
  ) : super(const []) {
    _load(raw);
  }

  final Future<bool> Function(String value) _save;

  void _load(String? raw) {
    if (raw == null || raw.isEmpty) {
      state = const [];
      return;
    }
    try {
      final data = jsonDecode(raw) as List<dynamic>;
      state = data
          .map((entry) => FocusSession.fromJson(entry as Map<String, dynamic>))
          .toList(growable: false)
        ..sort((a, b) => b.endedAt.compareTo(a.endedAt));
    } catch (_) {
      state = const [];
    }
  }

  Future<void> _persist() async {
    final raw = jsonEncode(state.map((e) => e.toJson()).toList());
    await _save(raw);
  }

  Future<void> addSession(FocusSession session) async {
    state = [...state, session]..sort((a, b) => b.endedAt.compareTo(a.endedAt));
    await _persist();
  }

  Future<void> deleteSession(String id) async {
    state = state.where((session) => session.id != id).toList(growable: false);
    await _persist();
  }

  Future<void> clearAll() async {
    state = const [];
    await _persist();
  }
}

class FocusCategoriesNotifier extends StateNotifier<List<String>> {
  FocusCategoriesNotifier(
    String? raw,
    this._save,
  ) : super(const []) {
    _load(raw);
  }

  final Future<bool> Function(String value) _save;

  void _load(String? raw) {
    if (raw == null || raw.isEmpty) {
      state = _kDefaultCategories;
      return;
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final values = decoded.map((e) => e.toString().trim()).where((e) {
        return e.isNotEmpty;
      }).toList(growable: false);
      state = values.isEmpty ? _kDefaultCategories : values;
    } catch (_) {
      state = _kDefaultCategories;
    }
  }

  Future<void> _persist() async {
    await _save(jsonEncode(state));
  }

  Future<void> addCategory(String category) async {
    final value = category.trim();
    if (value.isEmpty) {
      return;
    }
    final exists =
        state.any((item) => item.toLowerCase() == value.toLowerCase());
    if (exists) {
      return;
    }
    state = [...state, value];
    await _persist();
  }

  Future<void> removeCategory(String category) async {
    state = state.where((item) => item != category).toList(growable: false);
    if (state.isEmpty) {
      state = _kDefaultCategories;
    }
    await _persist();
  }
}

class FocusTimerNotifier extends StateNotifier<FocusTimerState> {
  FocusTimerNotifier() : super(FocusTimerState.idle);

  void start(String category) {
    if (state.isRunning) {
      return;
    }

    state = state.copyWith(
      isRunning: true,
      category: category,
      startedAt: DateTime.now(),
    );
  }

  Duration get liveElapsed {
    if (!state.isRunning || state.startedAt == null) {
      return state.elapsedBeforePause;
    }
    return state.elapsedBeforePause +
        DateTime.now().difference(state.startedAt!);
  }

  void pause() {
    if (!state.isRunning || state.startedAt == null) {
      return;
    }
    state = state.copyWith(
      isRunning: false,
      clearStartedAt: true,
      elapsedBeforePause: liveElapsed,
    );
  }

  void reset() {
    state = FocusTimerState.idle;
  }

  Future<FocusSession?> stopAndCreateSession() async {
    if (state.category == null) {
      reset();
      return null;
    }

    final endedAt = DateTime.now();
    final elapsed = liveElapsed;
    final startedAt = endedAt.subtract(elapsed);

    final session = FocusSession(
      id: endedAt.microsecondsSinceEpoch.toString(),
      category: state.category!,
      startedAt: startedAt,
      endedAt: endedAt,
    );

    reset();
    if (session.duration.inSeconds <= 0) {
      return null;
    }
    return session;
  }
}
