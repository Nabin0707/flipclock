import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_architecture/features/focus/domain/focus_models.dart';
import 'package:flutter_clean_architecture/features/focus/providers/focus_provider.dart';

void main() {
  group('calculateFocusAnalytics', () {
    test('returns empty analytics for empty sessions', () {
      final analytics = calculateFocusAnalytics(
        const [],
        now: DateTime(2026, 4, 6, 12),
      );

      expect(analytics.total, Duration.zero);
      expect(analytics.todayPercent, 0);
      expect(analytics.categoryBreakdown, isEmpty);
    });

    test('computes daily weekly monthly yearly totals and averages', () {
      final now = DateTime(2026, 4, 6, 12); // Monday
      final sessions = [
        FocusSession(
          id: '1',
          category: 'Coding',
          startedAt: DateTime(2026, 4, 6, 9),
          endedAt: DateTime(2026, 4, 6, 11),
        ), // 2h today
        FocusSession(
          id: '2',
          category: 'Study',
          startedAt: DateTime(2026, 4, 4, 10),
          endedAt: DateTime(2026, 4, 4, 11),
        ), // 1h this month + year
        FocusSession(
          id: '3',
          category: 'Coding',
          startedAt: DateTime(2026, 1, 10, 8),
          endedAt: DateTime(2026, 1, 10, 10),
        ), // 2h this year
        FocusSession(
          id: '4',
          category: 'Gaming',
          startedAt: DateTime(2025, 12, 31, 22),
          endedAt: DateTime(2025, 12, 31, 23),
        ), // 1h previous year, only in total
      ];

      final analytics = calculateFocusAnalytics(sessions, now: now);

      expect(analytics.today, const Duration(hours: 2));
      expect(analytics.thisWeek, const Duration(hours: 2));
      expect(analytics.thisMonth, const Duration(hours: 3));
      expect(analytics.thisYear, const Duration(hours: 5));
      expect(analytics.total, const Duration(hours: 6));

      expect(
        analytics.todayPercent,
        closeTo((120 / 1440) * 100, 0.001),
      );
      expect(analytics.weeklyAverage, const Duration(minutes: 17));
      expect(analytics.monthlyAverage, const Duration(minutes: 6));

      expect(analytics.categoryBreakdown['Coding'], const Duration(hours: 4));
      expect(analytics.categoryBreakdown['Study'], const Duration(hours: 1));
      expect(analytics.categoryBreakdown['Gaming'], const Duration(hours: 1));
    });
  });
}
