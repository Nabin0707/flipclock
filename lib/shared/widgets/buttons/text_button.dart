import 'package:flutter/material.dart';

// TODO: Customize text button appearance and add variants
/// Text button widget for secondary actions
/// Used for links, secondary actions, or less prominent buttons
/// All styling is controlled by theme - no hardcoded values
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonChild = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Text(text),
                ],
              )
            : Text(text);

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: buttonChild,
    );
  }
}
