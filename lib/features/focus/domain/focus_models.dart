import 'package:flutter/foundation.dart';

enum FocusAnalyticsRange { day, week, month, year }

@immutable
class FocusSession {
  const FocusSession({
    required this.id,
    required this.category,
    required this.startedAt,
    required this.endedAt,
  });

  final String id;
  final String category;
  final DateTime startedAt;
  final DateTime endedAt;

  Duration get duration {
    final diff = endedAt.difference(startedAt);
    return diff.isNegative ? Duration.zero : diff;
  }

  FocusSession copyWith({
    String? id,
    String? category,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return FocusSession(
      id: id ?? this.id,
      category: category ?? this.category,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt.toIso8601String(),
    };
  }

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'] as String,
      category: json['category'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
    );
  }
}

@immutable
class FocusTimerState {
  const FocusTimerState({
    required this.isRunning,
    required this.category,
    required this.startedAt,
    required this.elapsedBeforePause,
  });

  final bool isRunning;
  final String? category;
  final DateTime? startedAt;
  final Duration elapsedBeforePause;

  static const FocusTimerState idle = FocusTimerState(
    isRunning: false,
    category: null,
    startedAt: null,
    elapsedBeforePause: Duration.zero,
  );

  FocusTimerState copyWith({
    bool? isRunning,
    String? category,
    DateTime? startedAt,
    Duration? elapsedBeforePause,
    bool clearCategory = false,
    bool clearStartedAt = false,
  }) {
    return FocusTimerState(
      isRunning: isRunning ?? this.isRunning,
      category: clearCategory ? null : (category ?? this.category),
      startedAt: clearStartedAt ? null : (startedAt ?? this.startedAt),
      elapsedBeforePause: elapsedBeforePause ?? this.elapsedBeforePause,
    );
  }
}

@immutable
class FocusAnalytics {
  const FocusAnalytics({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
    required this.total,
    required this.todayPercent,
    required this.weeklyAverage,
    required this.monthlyAverage,
    required this.categoryBreakdown,
  });

  final Duration today;
  final Duration thisWeek;
  final Duration thisMonth;
  final Duration thisYear;
  final Duration total;
  final double todayPercent;
  final Duration weeklyAverage;
  final Duration monthlyAverage;
  final Map<String, Duration> categoryBreakdown;

  static const FocusAnalytics empty = FocusAnalytics(
    today: Duration.zero,
    thisWeek: Duration.zero,
    thisMonth: Duration.zero,
    thisYear: Duration.zero,
    total: Duration.zero,
    todayPercent: 0,
    weeklyAverage: Duration.zero,
    monthlyAverage: Duration.zero,
    categoryBreakdown: <String, Duration>{},
  );
}

@immutable
class FocusBucket {
  const FocusBucket({required this.label, required this.duration});

  final String label;
  final Duration duration;
}

@immutable
class FocusRangeAnalytics {
  const FocusRangeAnalytics({
    required this.range,
    required this.buckets,
    required this.total,
    required this.averagePerBucket,
    required this.focusPercent,
    required this.categoryBreakdown,
  });

  final FocusAnalyticsRange range;
  final List<FocusBucket> buckets;
  final Duration total;
  final Duration averagePerBucket;
  final double focusPercent;
  final Map<String, Duration> categoryBreakdown;

  static FocusRangeAnalytics empty(FocusAnalyticsRange range) {
    return FocusRangeAnalytics(
      range: range,
      buckets: const [],
      total: Duration.zero,
      averagePerBucket: Duration.zero,
      focusPercent: 0,
      categoryBreakdown: const {},
    );
  }
}
