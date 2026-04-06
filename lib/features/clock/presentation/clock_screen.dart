import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/core/theme/flip_clock_theme.dart';
import 'package:flutter_clean_architecture/core/utils/time_formatter.dart';
import 'package:flutter_clean_architecture/features/clock/providers/clock_provider.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:flutter_clean_architecture/widgets/fullscreen_flip_clock_face.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ClockScreen extends ConsumerStatefulWidget {
  const ClockScreen({super.key});

  @override
  ConsumerState<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends ConsumerState<ClockScreen> {
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isFullscreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    });
  }

  Future<void> _setFullscreen(bool value) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isFullscreen = value;
    });

    await SystemChrome.setEnabledSystemUIMode(
      value ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clockAsync = ref.watch(clockProvider);
    final is24h = ref.watch(clockFormatProvider);
    final flipTheme = ref.watch(settingsProvider);

    Widget buildClockBody() {
      return clockAsync.when(
        data: (now) {
          final displayHours =
              is24h ? now.hour : (now.hour % 12 == 0 ? 12 : now.hour % 12);
          return _ClockBody(
            hours: displayHours,
            minutes: now.minute,
            seconds: now.second,
            dateString: formatDate(now),
            is24h: is24h,
            amPm: now.hour < 12 ? 'AM' : 'PM',
            flipTheme: flipTheme,
          );
        },
        loading: () {
          final now = DateTime.now();
          return _ClockBody(
            hours: now.hour,
            minutes: now.minute,
            seconds: now.second,
            dateString: formatDate(now),
            is24h: is24h,
            amPm: now.hour < 12 ? 'AM' : 'PM',
            flipTheme: flipTheme,
          );
        },
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: flipTheme.backgroundColor,
      appBar: _isFullscreen
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Clock',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      ref.read(clockFormatProvider.notifier).toggle(),
                  child: Text(
                    is24h ? '24H' : '12H',
                    style: TextStyle(
                      color: flipTheme.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.apps_outlined, color: Colors.white54),
                  tooltip: 'Tools',
                  onSelected: (value) {
                    switch (value) {
                      case 'focus':
                        context.push(Routes.focus);
                        break;
                      case 'timer':
                        context.push(Routes.timer);
                        break;
                      case 'stopwatch':
                        context.push(Routes.stopwatch);
                        break;
                      case 'pomodoro':
                        context.push(Routes.pomodoro);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'focus', child: Text('Focus Mode')),
                    PopupMenuItem(value: 'timer', child: Text('Timer')),
                    PopupMenuItem(value: 'stopwatch', child: Text('Stopwatch')),
                    PopupMenuItem(value: 'pomodoro', child: Text('Pomodoro')),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: Colors.white54),
                  onPressed: () => context.push(Routes.settings),
                  tooltip: 'Settings',
                ),
                IconButton(
                  onPressed: () => _setFullscreen(true),
                  icon: const Icon(Icons.fullscreen, color: Colors.white54),
                  tooltip: 'Fullscreen',
                ),
              ],
            ),
      body: _isFullscreen
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _setFullscreen(false);
              },
              onDoubleTap: () {
                _setFullscreen(false);
              },
              child: buildClockBody(),
            )
          : buildClockBody(),
    );
  }
}

class _ClockBody extends StatelessWidget {
  const _ClockBody({
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.dateString,
    required this.is24h,
    required this.amPm,
    required this.flipTheme,
  });

  final int hours;
  final int minutes;
  final int seconds;
  final String dateString;
  final bool is24h;
  final String amPm;
  final FlipClockTheme flipTheme;

  @override
  Widget build(BuildContext context) {
    return FullscreenFlipClockFace(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      dateString: dateString,
      flipTheme: flipTheme,
      secondaryLabel: is24h ? null : '$amPm mode',
    );
  }
}
