import 'package:flutter/material.dart';

// TODO: Add more icon button variants if needed
/// Custom icon button widget with customizable appearance
/// Used for icon-only actions
/// All styling is controlled by theme - no hardcoded values
class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );

    return tooltip != null
        ? Tooltip(
            message: tooltip!,
            child: button,
          )
        : button;
  }
}

/// Circular icon button with filled background
class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = IconButton.filled(
      icon: Icon(icon),
      onPressed: onPressed,
    );

    return tooltip != null
        ? Tooltip(
            message: tooltip!,
            child: button,
          )
        : button;
  }
}
