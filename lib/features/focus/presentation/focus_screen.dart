import 'dart:async';

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
    final analytics = ref.watch(focusAnalyticsProvider);
    final timerState = ref.watch(focusTimerProvider);
    final timerNotifier = ref.read(focusTimerProvider.notifier);

    _selectedCategory ??= categories.isNotEmpty ? categories.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Mode'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TimerCard(
            timerState: timerState,
            liveElapsed: timerNotifier.liveElapsed,
            selectedCategory: _selectedCategory,
            categories: categories,
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Session saved: ${_formatDuration(session.duration)} (${session.category})',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _AnalyticsCard(analytics: analytics),
          const SizedBox(height: 16),
          _CategoryBreakdownCard(analytics: analytics),
          const SizedBox(height: 16),
          _SessionsCard(sessions: sessions),
        ],
      ),
    );
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard({
    required this.timerState,
    required this.liveElapsed,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.onAddCategory,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onStopAndSave,
  });

  final FocusTimerState timerState;
  final Duration liveElapsed;
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddCategory;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onStopAndSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Focus Timer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onAddCategory,
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _formatDuration(liveElapsed),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
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
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({required this.analytics});

  final FocusAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Focus Analytics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _AnalyticsRow(
                label: 'Today', value: _formatDuration(analytics.today)),
            _AnalyticsRow(
                label: 'This Week', value: _formatDuration(analytics.thisWeek)),
            _AnalyticsRow(
                label: 'This Month',
                value: _formatDuration(analytics.thisMonth)),
            _AnalyticsRow(
                label: 'This Year', value: _formatDuration(analytics.thisYear)),
            _AnalyticsRow(
                label: 'Total', value: _formatDuration(analytics.total)),
            _AnalyticsRow(
              label: 'Today Focus %',
              value: '${analytics.todayPercent.toStringAsFixed(1)}%',
            ),
            _AnalyticsRow(
              label: 'Avg / Day (Weekly)',
              value: _formatDuration(analytics.weeklyAverage),
            ),
            _AnalyticsRow(
              label: 'Avg / Day (Monthly)',
              value: _formatDuration(analytics.monthlyAverage),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({required this.analytics});

  final FocusAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    final entries = analytics.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              const Text('No focus sessions yet.')
            else
              ...entries.map((entry) {
                return _AnalyticsRow(
                  label: entry.key,
                  value: _formatDuration(entry.value),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _SessionsCard extends StatelessWidget {
  const _SessionsCard({required this.sessions});

  final List<FocusSession> sessions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Sessions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (sessions.isEmpty)
              const Text('No sessions saved yet.')
            else
              ...sessions.take(12).map((session) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(session.category),
                  subtitle: Text(session.startedAt.toLocal().toString()),
                  trailing: Text(_formatDuration(session.duration)),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsRow extends StatelessWidget {
  const _AnalyticsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
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
