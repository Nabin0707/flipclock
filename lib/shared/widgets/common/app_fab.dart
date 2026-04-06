import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Enhanced Floating Action Button with multiple variants
class AppFAB extends StatelessWidget {
  const AppFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.label,
    this.mini = false,
    this.heroTag,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final bool mini;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
        heroTag: heroTag,
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      mini: mini,
      heroTag: heroTag,
      child: Icon(icon),
    );
  }
}

/// FAB with badge (e.g., notification count)
class BadgedFAB extends StatelessWidget {
  const BadgedFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.notifications,
    this.badgeCount = 0,
    this.heroTag,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final int badgeCount;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          heroTag: heroTag,
          child: Icon(icon),
        ),
        if (badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 20.r,
                minHeight: 20.r,
              ),
              child: Center(
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Speed Dial FAB with multiple actions
class SpeedDialFAB extends StatefulWidget {
  const SpeedDialFAB({
    super.key,
    required this.children,
    this.icon = Icons.add,
    this.activeIcon = Icons.close,
    this.heroTag,
  });

  final List<SpeedDialChild> children;
  final IconData icon;
  final IconData activeIcon;
  final Object? heroTag;

  @override
  State<SpeedDialFAB> createState() => _SpeedDialFABState();
}

class _SpeedDialFABState extends State<SpeedDialFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Backdrop
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              color: Colors.transparent,
            ),
          ),

        // Children
        ...widget.children.reversed.map((child) {
          return ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (child.label != null) ...[
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8.r),
                      color: theme.colorScheme.surface,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          child.label!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  FloatingActionButton(
                    mini: true,
                    heroTag: child.heroTag,
                    backgroundColor: child.backgroundColor,
                    foregroundColor: child.foregroundColor,
                    onPressed: () {
                      _toggle();
                      child.onPressed?.call();
                    },
                    child: Icon(child.icon),
                  ),
                ],
              ),
            ),
          );
        }),

        // Main FAB
        FloatingActionButton(
          heroTag: widget.heroTag,
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animation,
          ),
        ),
      ],
    );
  }
}

/// Speed dial child item
class SpeedDialChild {
  const SpeedDialChild({
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  });

  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Object? heroTag;
}

/// Morphing FAB that expands into a bottom sheet
class MorphingFAB extends StatelessWidget {
  const MorphingFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.expandedChild,
    this.heroTag,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Widget expandedChild;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => expandedChild,
        );
      },
      child: Icon(icon),
    );
  }
}
