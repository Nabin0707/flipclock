import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/providers/settings_provider.dart';
import 'package:flutter_clean_architecture/features/timer/providers/timer_provider.dart';
import 'package:flutter_clean_architecture/widgets/flip_clock_display.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with SingleTickerProviderStateMixin {
  int _selectedHours = 0;
  int _selectedMinutes = 5;
  int _selectedSeconds = 0;
  bool _pickerMode = true;

  late AnimationController _flashController;
  late Animation<Color?> _flashColor;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flashColor = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.7),
    ).animate(_flashController);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  void _startTimer() {
    final duration = Duration(
      hours: _selectedHours,
      minutes: _selectedMinutes,
      seconds: _selectedSeconds,
    );
    if (duration == Duration.zero) return;
    ref.read(timerProvider.notifier).setDuration(duration);
    ref.read(timerProvider.notifier).start();
    setState(() => _pickerMode = false);
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final flipTheme = ref.watch(settingsProvider);

    ref.listen(timerProvider, (prev, next) {
      if (next.isFinished && !(prev?.isFinished ?? false)) {
        _flashController.repeat(reverse: true);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _flashController.stop();
            _flashController.reset();
            ref.read(timerProvider.notifier).clearFinished();
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: flipTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Timer',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(
              timerState.loopMode ? Icons.loop : Icons.loop_outlined,
              color: timerState.loopMode
                  ? flipTheme.accentColor
                  : Colors.white38,
            ),
            onPressed: () => ref.read(timerProvider.notifier).toggleLoop(),
            tooltip: 'Loop mode',
          ),
        ],
      ),
      body: Stack(
        children: [
          _pickerMode || timerState.totalDuration == Duration.zero
              ? _buildPicker(flipTheme)
              : _buildRunning(timerState, flipTheme),
          AnimatedBuilder(
            animation: _flashController,
            builder: (context, _) => _flashController.isAnimating
                ? Container(color: _flashColor.value)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(dynamic flipTheme) {
    final accentColor = flipTheme.accentColor as Color;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Set Timer',
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _WheelPicker(
              max: 24,
              value: _selectedHours,
              label: 'H',
              color: accentColor,
              onChanged: (v) => setState(() => _selectedHours = v),
            ),
            const SizedBox(width: 16),
            _WheelPicker(
              max: 60,
              value: _selectedMinutes,
              label: 'M',
              color: accentColor,
              onChanged: (v) => setState(() => _selectedMinutes = v),
            ),
            const SizedBox(width: 16),
            _WheelPicker(
              max: 60,
              value: _selectedSeconds,
              label: 'S',
              color: accentColor,
              onChanged: (v) => setState(() => _selectedSeconds = v),
            ),
          ],
        ),
        const SizedBox(height: 48),
        GestureDetector(
          onTap: _startTimer,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withOpacity(0.2),
              border: Border.all(color: accentColor, width: 2),
            ),
            child: Icon(Icons.play_arrow, color: accentColor, size: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildRunning(TimerState timerState, dynamic flipTheme) {
    final accentColor = flipTheme.accentColor as Color;
    final r = timerState.remaining;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 320,
              height: 320,
              child: CircularProgressIndicator(
                value: 1 - timerState.progress,
                strokeWidth: 4,
                backgroundColor: Colors.white12,
                color: accentColor,
              ),
            ),
            FlipClockDisplay(
              hours: r.inHours,
              minutes: r.inMinutes.remainder(60),
              seconds: r.inSeconds.remainder(60),
              showSeconds: true,
            ),
          ],
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CircleBtn(
              icon: timerState.isRunning ? Icons.pause : Icons.play_arrow,
              color: accentColor,
              onTap: timerState.isRunning
                  ? () => ref.read(timerProvider.notifier).pause()
                  : () => ref.read(timerProvider.notifier).start(),
              size: 64,
            ),
            const SizedBox(width: 24),
            _CircleBtn(
              icon: Icons.refresh,
              color: Colors.white38,
              onTap: () {
                ref.read(timerProvider.notifier).reset();
                setState(() => _pickerMode = true);
              },
              size: 48,
            ),
          ],
        ),
      ],
    );
  }
}

class _WheelPicker extends StatefulWidget {
  const _WheelPicker({
    required this.max,
    required this.value,
    required this.label,
    required this.color,
    required this.onChanged,
  });

  final int max;
  final int value;
  final String label;
  final Color color;
  final ValueChanged<int> onChanged;

  @override
  State<_WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<_WheelPicker> {
  late FixedExtentScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = FixedExtentScrollController(initialItem: widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: widget.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 60,
          height: 140,
          child: ListWheelScrollView.useDelegate(
            controller: _ctrl,
            itemExtent: 40,
            perspective: 0.004,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: widget.onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.max,
              builder: (context, index) => Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}
