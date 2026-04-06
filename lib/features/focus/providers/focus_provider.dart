import 'dart:convert';

import 'package:flutter/material.dart';
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

const _kCategoryPalette = <Color>[
  Color(0xFF4FC3F7),
  Color(0xFFFFB74D),
  Color(0xFFA5D6A7),
  Color(0xFFE57373),
  Color(0xFFCE93D8),
  Color(0xFF90CAF9),
  Color(0xFFFFCC80),
  Color(0xFF80CBC4),
  Color(0xFFF48FB1),
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

final focusRangeProvider =
    StateProvider<FocusAnalyticsRange>((ref) => FocusAnalyticsRange.week);

final focusRangeAnalyticsProvider = Provider<FocusRangeAnalytics>((ref) {
  final sessions = ref.watch(focusSessionsProvider);
  final range = ref.watch(focusRangeProvider);
  return calculateFocusRangeAnalytics(
    sessions,
    range: range,
    now: DateTime.now(),
  );
});

final focusCategoryColorsProvider = Provider<Map<String, Color>>((ref) {
  final categories = ref.watch(focusCategoriesProvider);
  final map = <String, Color>{};
  for (final category in categories) {
    map[category] = _colorForCategory(category);
  }
  return Map<String, Color>.unmodifiable(map);
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

FocusRangeAnalytics calculateFocusRangeAnalytics(
  List<FocusSession> sessions, {
  required FocusAnalyticsRange range,
  required DateTime now,
}) {
  if (sessions.isEmpty) {
    return FocusRangeAnalytics.empty(range);
  }

  final bucketLabels = _buildLabels(range, now);
  final bucketDurations = List<Duration>.filled(
    bucketLabels.length,
    Duration.zero,
    growable: false,
  );
  final categoryMap = <String, Duration>{};

  final start = _rangeStart(range, now);
  final endExclusive = _rangeEndExclusive(range, now);

  for (final session in sessions) {
    final endedAt = session.endedAt;
    if (endedAt.isBefore(start) || !endedAt.isBefore(endExclusive)) {
      continue;
    }

    final duration = session.duration;
    final index = _bucketIndex(range, endedAt, start);
    if (index >= 0 && index < bucketDurations.length) {
      bucketDurations[index] = bucketDurations[index] + duration;
    }
    categoryMap[session.category] =
        (categoryMap[session.category] ?? Duration.zero) + duration;
  }

  final buckets = List<FocusBucket>.generate(bucketLabels.length, (i) {
    return FocusBucket(label: bucketLabels[i], duration: bucketDurations[i]);
  }, growable: false);

  final total = bucketDurations.fold<Duration>(
    Duration.zero,
    (prev, item) => prev + item,
  );

  final averagePerBucket = bucketDurations.isEmpty
      ? Duration.zero
      : Duration(milliseconds: total.inMilliseconds ~/ bucketDurations.length);

  final rangeCapacityMinutes = _rangeCapacityMinutes(range, now);
  final focusPercent = rangeCapacityMinutes == 0
      ? 0
      : (total.inMinutes / rangeCapacityMinutes) * 100;

  return FocusRangeAnalytics(
    range: range,
    buckets: buckets,
    total: total,
    averagePerBucket: averagePerBucket,
    focusPercent: focusPercent.clamp(0.0, 100.0).toDouble(),
    categoryBreakdown: Map<String, Duration>.unmodifiable(categoryMap),
  );
}

DateTime _rangeStart(FocusAnalyticsRange range, DateTime now) {
  switch (range) {
    case FocusAnalyticsRange.day:
      return DateTime(now.year, now.month, now.day);
    case FocusAnalyticsRange.week:
      final dayStart = DateTime(now.year, now.month, now.day);
      return dayStart.subtract(Duration(days: now.weekday - 1));
    case FocusAnalyticsRange.month:
      return DateTime(now.year, now.month, 1);
    case FocusAnalyticsRange.year:
      return DateTime(now.year, 1, 1);
  }
}

DateTime _rangeEndExclusive(FocusAnalyticsRange range, DateTime now) {
  switch (range) {
    case FocusAnalyticsRange.day:
      return DateTime(now.year, now.month, now.day + 1);
    case FocusAnalyticsRange.week:
      final start = _rangeStart(range, now);
      return start.add(const Duration(days: 7));
    case FocusAnalyticsRange.month:
      return DateTime(now.year, now.month + 1, 1);
    case FocusAnalyticsRange.year:
      return DateTime(now.year + 1, 1, 1);
  }
}

int _bucketIndex(FocusAnalyticsRange range, DateTime endedAt, DateTime start) {
  switch (range) {
    case FocusAnalyticsRange.day:
      return endedAt.hour;
    case FocusAnalyticsRange.week:
      return endedAt.weekday - 1;
    case FocusAnalyticsRange.month:
      return endedAt.day - 1;
    case FocusAnalyticsRange.year:
      return endedAt.month - 1;
  }
}

List<String> _buildLabels(FocusAnalyticsRange range, DateTime now) {
  switch (range) {
    case FocusAnalyticsRange.day:
      return List<String>.generate(
        24,
        (i) => i.toString().padLeft(2, '0'),
        growable: false,
      );
    case FocusAnalyticsRange.week:
      return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    case FocusAnalyticsRange.month:
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      return List<String>.generate(
        daysInMonth,
        (i) => '${i + 1}',
        growable: false,
      );
    case FocusAnalyticsRange.year:
      return const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
  }
}

int _rangeCapacityMinutes(FocusAnalyticsRange range, DateTime now) {
  switch (range) {
    case FocusAnalyticsRange.day:
      return 24 * 60;
    case FocusAnalyticsRange.week:
      return 7 * 24 * 60;
    case FocusAnalyticsRange.month:
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      return daysInMonth * 24 * 60;
    case FocusAnalyticsRange.year:
      final daysInYear = DateTime(now.year, 12, 31)
              .difference(DateTime(now.year, 1, 1))
              .inDays +
          1;
      return daysInYear * 24 * 60;
  }
}

Color _colorForCategory(String category) {
  final hash = category.codeUnits
      .fold<int>(0, (prev, c) => (prev * 31 + c) & 0x7fffffff);
  final index = hash % _kCategoryPalette.length;
  return _kCategoryPalette[index];
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
      final seen = <String>{};
      final values = <String>[];
      for (final entry in decoded) {
        final value = entry.toString().trim();
        if (value.isEmpty) {
          continue;
        }
        final key = value.toLowerCase();
        if (seen.add(key)) {
          values.add(value);
        }
      }
      state = values.isEmpty ? _kDefaultCategories : values;
      // Persist sanitized categories to avoid future dropdown assertion crashes.
      _persist();
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
