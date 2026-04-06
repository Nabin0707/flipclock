import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add rich text editing features if needed
/// Multiline text field for longer text input
/// Used for comments, descriptions, etc.
/// Uses responsive sizing with flutter_screenutil
class MultilineTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final EdgeInsets? contentPadding;

  const MultilineTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.maxLines = 5,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.textInputAction,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      textInputAction: textInputAction ?? TextInputAction.newline,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        fontSize: ResponsiveFontSizes.md,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.r,
              vertical: 16.r,
            ),
        alignLabelWithHint: true,
        counterText: maxLength != null ? null : '',
      ),
    );
  }
}

/// Comment text field with character counter
class CommentTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const CommentTextField({
    super.key,
    this.controller,
    this.hintText,
    this.maxLength = 500,
    this.onChanged,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return MultilineTextField(
      controller: controller,
      hintText: hintText ?? 'Write a comment...',
      maxLines: 4,
      minLines: 3,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      focusNode: focusNode,
    );
  }
}

/// Description text field for longer descriptions
class DescriptionTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool required;

  const DescriptionTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.maxLength = 1000,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.required = false,
  });

  String? _defaultValidator(String? value) {
    if (required && (value == null || value.isEmpty)) {
      return 'Description is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultilineTextField(
      controller: controller,
      labelText: labelText ?? 'Description',
      hintText: hintText ?? 'Enter description...',
      maxLines: 6,
      minLines: 4,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator ?? _defaultValidator,
      focusNode: focusNode,
    );
  }
}
