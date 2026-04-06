import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.digit,
    required this.height,
    required this.width,
    required this.cardColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontSize,
    required this.fontFamily,
    required this.flipDuration,
    this.glowEnabled = false,
    this.glowColor = Colors.amber,
  });

  final int digit;
  final double height;
  final double width;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final String fontFamily;
  final Duration flipDuration;
  final bool glowEnabled;
  final Color glowColor;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentDigit = 0;
  int _nextDigit = 0;

  @override
  void initState() {
    super.initState();
    _currentDigit = widget.digit;
    _nextDigit = widget.digit;
    _controller = AnimationController(
      vsync: this,
      duration: widget.flipDuration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _nextDigit = widget.digit;
      _controller.forward(from: 0).then((_) {
        setState(() {
          _currentDigit = _nextDigit;
        });
        _controller.reset();
      });
    }
    if (oldWidget.flipDuration != widget.flipDuration) {
      _controller.duration = widget.flipDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: widget.cardColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: widget.glowEnabled
          ? [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              // Static bottom half of next digit (revealed during second phase)
              _HalfCard(
                digit: _nextDigit,
                isTop: false,
                width: widget.width,
                height: widget.height,
                cardColor: widget.cardColor,
                textColor: widget.textColor,
                borderRadius: widget.borderRadius,
                fontSize: widget.fontSize,
                fontFamily: widget.fontFamily,
                decoration: cardDecoration,
              ),
              // Static top half (always shows current digit)
              _HalfCard(
                digit: _currentDigit,
                isTop: true,
                width: widget.width,
                height: widget.height,
                cardColor: widget.cardColor,
                textColor: widget.textColor,
                borderRadius: widget.borderRadius,
                fontSize: widget.fontSize,
                fontFamily: widget.fontFamily,
                decoration: cardDecoration,
              ),
              // Animated flipping bottom half
              if (_animation.value < 1.0)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildFlippingHalf(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlippingHalf() {
    final progress = _animation.value;
    // Phase 1 (0 → 0.5): old bottom folds down (0 → π/2)
    // Phase 2 (0.5 → 1.0): new bottom unfolds (π/2 → 0)
    final isFirstHalf = progress <= 0.5;
    final digit = isFirstHalf ? _currentDigit : _nextDigit;
    final angle = isFirstHalf
        ? math.pi * progress // 0 → π/2
        : math.pi * (1 - progress); // π/2 → 0

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.003)
        ..rotateX(-angle),
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: 0.5,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: _buildCardFace(digit, isFlipped: !isFirstHalf),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFace(int digit, {bool isFlipped = false}) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(widget.borderRadius),
          bottomRight: Radius.circular(widget.borderRadius),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              digit.toString(),
              style: TextStyle(
                fontFamily: widget.fontFamily,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          ),
          // Shading overlay during flip
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.borderRadius),
                bottomRight: Radius.circular(widget.borderRadius),
              ),
              color: Colors.black.withOpacity(
                isFlipped ? 0.2 : (_animation.value * 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfCard extends StatelessWidget {
  const _HalfCard({
    required this.digit,
    required this.isTop,
    required this.width,
    required this.height,
    required this.cardColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontSize,
    required this.fontFamily,
    required this.decoration,
  });

  final int digit;
  final bool isTop;
  final double width;
  final double height;
  final Color cardColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final String fontFamily;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
        heightFactor: 0.5,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(
              topLeft: isTop ? Radius.circular(borderRadius) : Radius.zero,
              topRight: isTop ? Radius.circular(borderRadius) : Radius.zero,
              bottomLeft: isTop ? Radius.zero : Radius.circular(borderRadius),
              bottomRight: isTop ? Radius.zero : Radius.circular(borderRadius),
            ),
            boxShadow: decoration.boxShadow,
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  digit.toString(),
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              // Divider line in middle
              if (isTop)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
