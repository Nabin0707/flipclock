import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FlipClockShell extends ConsumerWidget {
  const FlipClockShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    _TabItem(icon: Icons.access_time, label: 'Clock'),
    _TabItem(icon: Icons.timer_outlined, label: 'Stopwatch'),
    _TabItem(icon: Icons.hourglass_bottom_outlined, label: 'Timer'),
    _TabItem(icon: Icons.self_improvement, label: 'Pomodoro'),
    _TabItem(icon: Icons.visibility_outlined, label: 'Focus'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flipTheme = ref.watch(settingsProvider);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0D0D0D),
          selectedItemColor: flipTheme.accentColor,
          unselectedItemColor: Colors.white38,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          items: _tabs
              .map(
                (t) => BottomNavigationBarItem(
                  icon: Icon(t.icon),
                  label: t.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
