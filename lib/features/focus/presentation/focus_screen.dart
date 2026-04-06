import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/features/clock/providers/clock_provider.dart';
import 'package:flutter_clean_architecture/widgets/flip_clock_display.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _quotes = [
  'The secret of getting ahead is getting started.',
  'Focus on being productive instead of busy.',
  'Do the hard jobs first.',
  "You don't have to be great to start, but you have to start to be great.",
  'The only way to do great work is to love what you do.',
  'Small steps every day lead to great achievements.',
  'Discipline is choosing between what you want now and what you want most.',
  'Stay focused, go after your dreams.',
  'The future depends on what you do today.',
  'Work hard in silence, let success make the noise.',
  'Push yourself, because no one else is going to do it for you.',
  'Dream it. Wish it. Do it.',
];

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;
  late final Animation<Color?> _breathColor;

  final _random = math.Random();
  late String _quote;
  bool _showBreathing = false;

  @override
  void initState() {
    super.initState();
    _quote = _quotes[_random.nextInt(_quotes.length)];
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breathScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    _breathColor = ColorTween(
      begin: Colors.blue.withOpacity(0.3),
      end: Colors.teal.withOpacity(0.6),
    ).animate(_breathController);
    _breathController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathController.forward();
      }
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  void _toggleBreathing() {
    setState(() => _showBreathing = !_showBreathing);
    if (_showBreathing) {
      _breathController.forward();
    } else {
      _breathController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clockAsync = ref.watch(clockProvider);
    final flipTheme = ref.watch(settingsProvider);

    final now = clockAsync.when(
      data: (dt) => dt,
      loading: () => DateTime.now(),
      error: (_, __) => DateTime.now(),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0D0D0D),
                  flipTheme.backgroundColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.4),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.do_not_disturb_on,
                              color: Colors.red,
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Do Not Disturb',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                FlipClockDisplay(
                  hours: now.hour,
                  minutes: now.minute,
                  seconds: now.second,
                  showSeconds: true,
                  cardScale: 1.2,
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    '"$_quote"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  onPressed: _toggleBreathing,
                  icon: Icon(
                    _showBreathing ? Icons.air : Icons.air_outlined,
                    color: Colors.teal.withOpacity(0.8),
                  ),
                  label: Text(
                    _showBreathing
                        ? 'Stop Breathing'
                        : 'Breathing Exercise',
                    style: TextStyle(color: Colors.teal.withOpacity(0.8)),
                  ),
                ),
                if (_showBreathing)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: _BreathingWidget(
                      controller: _breathController,
                      scale: _breathScale,
                      color: _breathColor,
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingWidget extends AnimatedWidget {
  const _BreathingWidget({
    required AnimationController controller,
    required this.scale,
    required this.color,
  }) : super(listenable: controller);

  final Animation<double> scale;
  final Animation<Color?> color;

  @override
  Widget build(BuildContext context) {
    final ctrl = listenable as AnimationController;
    final phase = ctrl.value;
    final String label;
    if (phase < 0.33) {
      label = 'Inhale...';
    } else if (phase < 0.66) {
      label = 'Hold...';
    } else {
      label = 'Exhale...';
    }

    return Column(
      children: [
        Transform.scale(
          scale: scale.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.value ?? Colors.teal.withOpacity(0.3),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.teal.withOpacity(0.8),
            fontSize: 14,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
