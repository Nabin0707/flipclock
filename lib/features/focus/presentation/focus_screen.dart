import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/focus/domain/focus_models.dart';
import 'package:flutter_clean_architecture/features/focus/providers/focus_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  Timer? _ticker;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _promptAddCategory(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Focus Category'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g. Research'),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) {
      return;
    }

    final category = result.trim();
    if (category.isEmpty) {
      return;
    }

    await ref.read(focusCategoriesProvider.notifier).addCategory(category);
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(focusCategoriesProvider);
    final sessions = ref.watch(focusSessionsProvider);
    final timerState = ref.watch(focusTimerProvider);
    final timerNotifier = ref.read(focusTimerProvider.notifier);
    final summary = ref.watch(focusAnalyticsProvider);
    final range = ref.watch(focusRangeProvider);
    final rangeAnalytics = ref.watch(focusRangeAnalyticsProvider);
    final categoryColors = ref.watch(focusCategoryColorsProvider);

    _selectedCategory ??= categories.isNotEmpty ? categories.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFF070808),
      appBar: AppBar(
        title: const Text('Focus Mode'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              children: [
                _FullScreenFocusHero(
                  maxHeight: constraints.maxHeight,
                  timerState: timerState,
                  liveElapsed: timerNotifier.liveElapsed,
                  selectedCategory: _selectedCategory,
                  categories: categories,
                  categoryColors: categoryColors,
                  onCategoryChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  onAddCategory: () => _promptAddCategory(context),
                  onStart: () {
                    if (_selectedCategory == null) {
                      return;
                    }
                    timerNotifier.start(_selectedCategory!);
                  },
                  onPause: timerNotifier.pause,
                  onReset: timerNotifier.reset,
                  onStopAndSave: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final session = await timerNotifier.stopAndCreateSession();
                    if (!mounted || session == null) {
                      return;
                    }
                    await ref
                        .read(focusSessionsProvider.notifier)
                        .addSession(session);
                    if (!mounted) {
                      return;
                    }
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Session saved: ${_formatDuration(session.duration)} (${session.category})',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 12),
                _CategoryManagementCard(
                  categories: categories,
                  categoryColors: categoryColors,
                  onDelete: (category) async {
                    if (_selectedCategory == category) {
                      final remaining =
                          categories.where((item) => item != category).toList();
                      setState(() {
                        _selectedCategory =
                            remaining.isEmpty ? null : remaining.first;
                      });
                    }
                    await ref
                        .read(focusCategoriesProvider.notifier)
                        .removeCategory(category);
                  },
                ),
                const SizedBox(height: 12),
                _SessionsCard(
                  sessions: sessions,
                  categoryColors: categoryColors,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FullScreenFocusHero extends StatelessWidget {
  const _FullScreenFocusHero({
    required this.maxHeight,
    required this.timerState,
    required this.liveElapsed,
    required this.selectedCategory,
    required this.categories,
    required this.categoryColors,
    required this.onCategoryChanged,
    required this.onAddCategory,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onStopAndSave,
  });

  final double maxHeight;
  final FocusTimerState timerState;
  final Duration liveElapsed;
  final String? selectedCategory;
  final List<String> categories;
  final Map<String, Color> categoryColors;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddCategory;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onStopAndSave;

  @override
  Widget build(BuildContext context) {
    final cardHeight = (maxHeight * 0.45).clamp(280.0, 420.0);
    final activeColor =
        categoryColors[selectedCategory] ?? const Color(0xFFE8A020);

    return Container(
      width: double.infinity,
      height: cardHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1D23),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: activeColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: activeColor.withValues(alpha: 0.16),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  dropdownColor: const Color(0xFF242730),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Focus Category',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  items: categories
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: categoryColors[item] ?? Colors.white70,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(item),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onCategoryChanged,
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: onAddCategory,
                icon: const Icon(Icons.add),
                tooltip: 'Add category',
              ),
            ],
          ),
          const Spacer(),
          Text(
            _formatDuration(liveElapsed),
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 24,
                  color: activeColor.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            timerState.isRunning ? 'FOCUS ACTIVE' : 'READY TO FOCUS',
            style: TextStyle(
              letterSpacing: 1.8,
              color: activeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: timerState.isRunning ? null : onStart,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start'),
              ),
              OutlinedButton.icon(
                onPressed: timerState.isRunning ? onPause : null,
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
              ),
              OutlinedButton.icon(
                onPressed: timerState.isRunning ||
                        timerState.elapsedBeforePause > Duration.zero
                    ? onStopAndSave
                    : null,
                icon: const Icon(Icons.stop),
                label: const Text('Stop + Save'),
              ),
              TextButton.icon(
                onPressed: timerState.isRunning ||
                        timerState.elapsedBeforePause > Duration.zero
                    ? onReset
                    : null,
                icon: const Icon(Icons.restore),
                label: const Text('Reset'),
              ),
            ],
          ),
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

class _CategoryManagementCard extends StatelessWidget {
  const _CategoryManagementCard({
    required this.categories,
    required this.categoryColors,
    required this.onDelete,
  });

  final List<String> categories;
  final Map<String, Color> categoryColors;
  final ValueChanged<String> onDelete;

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
              'Categories',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                return InputChip(
                  label: Text(category),
                  onDeleted:
                      categories.length > 1 ? () => onDelete(category) : null,
                  avatar: CircleAvatar(
                    backgroundColor: categoryColors[category] ?? Colors.white,
                    radius: 8,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionsCard extends StatelessWidget {
  const _SessionsCard({required this.sessions, required this.categoryColors});

  final List<FocusSession> sessions;
  final Map<String, Color> categoryColors;

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
              'Recent Sessions',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            if (sessions.isEmpty)
              const Text('No sessions saved yet.',
                  style: TextStyle(color: Colors.white70))
            else
              ...sessions.take(10).map((session) {
                final dotColor =
                    categoryColors[session.category] ?? Colors.white;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: dotColor, radius: 8),
                  title: Text(
                    session.category,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    session.startedAt.toLocal().toString(),
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: Text(
                    _formatDuration(session.duration),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }),
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
