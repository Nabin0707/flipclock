import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/focus/domain/focus_models.dart';
import 'package:flutter_clean_architecture/features/focus/providers/focus_provider.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final categoryColors = ref.watch(focusCategoryColorsProvider);

    _selectedCategory ??= categories.isNotEmpty ? categories.first : null;

    return Scaffold(
      backgroundColor: const Color(0xFF070808),
      appBar: AppBar(
        title: const Text('Focus Mode'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.focusAnalytics),
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Open analytics',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          _FullScreenFocusHero(
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
  }
}

class _FullScreenFocusHero extends StatelessWidget {
  const _FullScreenFocusHero({
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
    final activeColor =
        categoryColors[selectedCategory] ?? const Color(0xFFE8A020);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 380),
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
        mainAxisSize: MainAxisSize.min,
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
                              Flexible(child: Text(item)),
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
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
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
          const SizedBox(height: 16),
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
                fontWeight: FontWeight.w700,
              ),
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
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            if (sessions.isEmpty)
              const Text(
                'No sessions saved yet.',
                style: TextStyle(color: Colors.white70),
              )
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

String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;

  final hh = hours.toString().padLeft(2, '0');
  final mm = minutes.toString().padLeft(2, '0');
  final ss = seconds.toString().padLeft(2, '0');
  return '$hh:$mm:$ss';
}
