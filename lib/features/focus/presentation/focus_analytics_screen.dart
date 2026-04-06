import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/focus/domain/focus_models.dart';
import 'package:flutter_clean_architecture/features/focus/providers/focus_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusAnalyticsScreen extends ConsumerWidget {
  const FocusAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(focusAnalyticsProvider);
    final range = ref.watch(focusRangeProvider);
    final rangeAnalytics = ref.watch(focusRangeAnalyticsProvider);
    final categoryColors = ref.watch(focusCategoryColorsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF070808),
      appBar: AppBar(
        title: const Text('Focus Analytics'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          _AnalyticsSummaryCard(summary: summary),
          const SizedBox(height: 12),
          _RangeSelector(
            selected: range,
            onChanged: (value) {
              if (value != null) {
                ref.read(focusRangeProvider.notifier).state = value;
              }
            },
          ),
          const SizedBox(height: 12),
          _BarGraphCard(rangeAnalytics: rangeAnalytics),
          const SizedBox(height: 12),
          _PieChartCard(
            rangeAnalytics: rangeAnalytics,
            categoryColors: categoryColors,
          ),
          const SizedBox(height: 12),
          _TrendChartCard(rangeAnalytics: rangeAnalytics),
        ],
      ),
    );
  }
}

class _AnalyticsSummaryCard extends StatelessWidget {
  const _AnalyticsSummaryCard({required this.summary});

  final FocusAnalytics summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1D23),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                _MetricBox(
                    label: 'Today', value: _formatDuration(summary.today)),
                const SizedBox(width: 8),
                _MetricBox(
                    label: 'Week', value: _formatDuration(summary.thisWeek)),
                const SizedBox(width: 8),
                _MetricBox(
                    label: 'Month', value: _formatDuration(summary.thisMonth)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _MetricBox(
                    label: 'Year', value: _formatDuration(summary.thisYear)),
                const SizedBox(width: 8),
                _MetricBox(
                    label: 'Total', value: _formatDuration(summary.total)),
                const SizedBox(width: 8),
                _MetricBox(
                  label: 'Today %',
                  value: '${summary.todayPercent.toStringAsFixed(1)}%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF252932),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 11)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.selected, required this.onChanged});

  final FocusAnalyticsRange selected;
  final ValueChanged<FocusAnalyticsRange?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<FocusAnalyticsRange>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: FocusAnalyticsRange.day, label: Text('Day')),
        ButtonSegment(value: FocusAnalyticsRange.week, label: Text('Week')),
        ButtonSegment(value: FocusAnalyticsRange.month, label: Text('Month')),
        ButtonSegment(value: FocusAnalyticsRange.year, label: Text('Year')),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.isEmpty ? null : set.first),
    );
  }
}

class _BarGraphCard extends StatelessWidget {
  const _BarGraphCard({required this.rangeAnalytics});

  final FocusRangeAnalytics rangeAnalytics;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1D23),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bar Graph',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: _BarGraph(buckets: rangeAnalytics.buckets),
            ),
            const SizedBox(height: 8),
            Text(
              'Total ${_formatDuration(rangeAnalytics.total)}  •  Avg ${_formatDuration(rangeAnalytics.averagePerBucket)}',
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieChartCard extends StatelessWidget {
  const _PieChartCard({
    required this.rangeAnalytics,
    required this.categoryColors,
  });

  final FocusRangeAnalytics rangeAnalytics;
  final Map<String, Color> categoryColors;

  @override
  Widget build(BuildContext context) {
    final entries = rangeAnalytics.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      color: const Color(0xFF1A1D23),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pie Chart (Category Share)',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('No data in selected range.',
                    style: TextStyle(color: Colors.white70)),
              )
            else
              Row(
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: _PieChart(
                      items: entries,
                      colors: categoryColors,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: entries.map((entry) {
                        final color = categoryColors[entry.key] ?? Colors.white;
                        final percent = rangeAnalytics.total.inMilliseconds == 0
                            ? 0
                            : (entry.value.inMilliseconds /
                                    rangeAnalytics.total.inMilliseconds) *
                                100;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                              Text(
                                '${percent.toStringAsFixed(1)}%',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _TrendChartCard extends StatelessWidget {
  const _TrendChartCard({required this.rangeAnalytics});

  final FocusRangeAnalytics rangeAnalytics;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1D23),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trend Graph',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 170,
              child: _TrendGraph(buckets: rangeAnalytics.buckets),
            ),
            const SizedBox(height: 8),
            Text(
              'Focus in range: ${rangeAnalytics.focusPercent.toStringAsFixed(2)}%',
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarGraph extends StatelessWidget {
  const _BarGraph({required this.buckets});

  final List<FocusBucket> buckets;

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) {
      return const Center(
          child: Text('No data', style: TextStyle(color: Colors.white70)));
    }

    final maxValue = buckets
        .map((bucket) => bucket.duration.inMinutes.toDouble())
        .fold<double>(0, math.max);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: buckets.map((bucket) {
        final minutes = bucket.duration.inMinutes.toDouble();
        final ratio = maxValue <= 0 ? 0 : (minutes / maxValue);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: (ratio * 130).clamp(2, 130).toDouble(),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8A020),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bucket.label,
                  style: const TextStyle(color: Colors.white54, fontSize: 9),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PieChart extends StatelessWidget {
  const _PieChart({required this.items, required this.colors});

  final List<MapEntry<String, Duration>> items;
  final Map<String, Color> colors;

  @override
  Widget build(BuildContext context) {
    final totalMs =
        items.fold<int>(0, (sum, item) => sum + item.value.inMilliseconds);
    if (totalMs == 0) {
      return const Center(
          child: Text('No data', style: TextStyle(color: Colors.white70)));
    }

    return CustomPaint(
      painter: _PiePainter(items: items, totalMs: totalMs, colors: colors),
      child: const SizedBox.expand(),
    );
  }
}

class _TrendGraph extends StatelessWidget {
  const _TrendGraph({required this.buckets});

  final List<FocusBucket> buckets;

  @override
  Widget build(BuildContext context) {
    if (buckets.length < 2) {
      return const Center(
          child:
              Text('Not enough data', style: TextStyle(color: Colors.white70)));
    }
    return CustomPaint(
      painter: _TrendPainter(buckets),
      child: const SizedBox.expand(),
    );
  }
}

class _PiePainter extends CustomPainter {
  const _PiePainter({
    required this.items,
    required this.totalMs,
    required this.colors,
  });

  final List<MapEntry<String, Duration>> items;
  final int totalMs;
  final Map<String, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    var start = -math.pi / 2;

    for (final entry in items) {
      final sweep = (entry.value.inMilliseconds / totalMs) * math.pi * 2;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.52
        ..color = colors[entry.key] ?? Colors.white;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.72),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) {
    return oldDelegate.totalMs != totalMs || oldDelegate.items != items;
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.buckets);

  final List<FocusBucket> buckets;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final values = buckets
        .map((b) => b.duration.inMinutes.toDouble())
        .toList(growable: false);
    final maxValue = values.fold<double>(0, math.max);
    final linePaint = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x =
          values.length == 1 ? 0.0 : (i / (values.length - 1)) * size.width;
      final ratio = maxValue <= 0 ? 0 : values[i] / maxValue;
      final y = size.height - (ratio * (size.height - 12)) - 6;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      canvas.drawCircle(
          Offset(x, y), 2.5, Paint()..color = const Color(0xFF4FC3F7));
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.buckets != buckets;
  }
}

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;

  final hh = hours.toString().padLeft(2, '0');
  final mm = minutes.toString().padLeft(2, '0');
  final ss = seconds.toString().padLeft(2, '0');
  return '$hh:$mm:$ss';
}
