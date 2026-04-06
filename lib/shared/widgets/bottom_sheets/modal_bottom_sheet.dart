import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: Add drag handle and custom animations
/// Show modal bottom sheet with custom design
Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
    isScrollControlled: isScrollControlled,
    builder: (context) => child,
  );
}

/// Modal bottom sheet with header and actions
class AppModalBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool showDragHandle;

  const AppModalBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              width: 40.r,
              height: 4.h,
              margin: EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Divider(height: 1.h, color: theme.dividerColor),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: content,
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            Divider(height: 1.h, color: theme.dividerColor),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: actions!
                      .map((action) => Expanded(child: action))
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Scrollable modal bottom sheet that takes full height
class ScrollableBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final bool showDragHandle;

  const ScrollableBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.showDragHandle = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    bool showDragHandle = true,
  }) {
    return showAppModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      child: ScrollableBottomSheet(
        title: title,
        content: content,
        showDragHandle: showDragHandle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            children: [
              if (showDragHandle)
                Container(
                  width: 40.r,
                  height: 4.h,
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h, color: theme.dividerColor),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(20.w),
                  children: [content],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// List bottom sheet for selection
class ListBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Function(T item)? onItemTap;
  final bool showDragHandle;

  const ListBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.onItemTap,
    this.showDragHandle = true,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(T item) itemBuilder,
    Function(T item)? onItemTap,
    bool showDragHandle = true,
  }) {
    return showAppModalBottomSheet<T>(
      context: context,
      child: ListBottomSheet<T>(
        title: title,
        items: items,
        itemBuilder: itemBuilder,
        onItemTap: onItemTap,
        showDragHandle: showDragHandle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              width: 40.r,
              height: 4.h,
              margin: EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Divider(height: 1.h, color: theme.dividerColor),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () {
                    onItemTap?.call(item);
                    Navigator.of(context).pop(item);
                  },
                  child: itemBuilder(item),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
