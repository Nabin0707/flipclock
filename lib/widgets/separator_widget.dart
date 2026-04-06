import 'package:flutter/material.dart';

class SeparatorWidget extends StatefulWidget {
  const SeparatorWidget({
    super.key,
    required this.color,
    required this.fontSize,
    this.pulseEnabled = true,
  });

  final Color color;
  final double fontSize;
  final bool pulseEnabled;

  @override
  State<SeparatorWidget> createState() => _SeparatorWidgetState();
}

class _SeparatorWidgetState extends State<SeparatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.1).animate(_controller);
    if (widget.pulseEnabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SeparatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pulseEnabled != widget.pulseEnabled) {
      if (widget.pulseEnabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity:
          widget.pulseEnabled ? _opacity : const AlwaysStoppedAnimation(1.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          ':',
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: widget.color,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
