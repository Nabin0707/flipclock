import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add more validation features (password strength matching, etc.)
/// Confirm password text field widget
/// Validates that the entered password matches the original password
/// Uses responsive sizing with flutter_screenutil
class ConfirmPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final bool enabled;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final Color? fillColor;
  final bool filled;

  const ConfirmPasswordTextField({
    super.key,
    required this.controller,
    required this.passwordController,
    this.labelText,
    this.hintText,
    this.textInputAction,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.obscureText = true,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.fillColor,
    this.filled = false,
  });

  @override
  State<ConfirmPasswordTextField> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      style: widget.style ??
          TextStyle(
            fontSize: ResponsiveFontSizes.md,
            color: colorScheme.onSurface,
          ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon ??
            IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: colorScheme.onSurfaceVariant,
                size: ResponsiveSpacing.iconSm,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.r,
              vertical: 16.r,
            ),
        labelStyle: widget.labelStyle ??
            TextStyle(
              fontSize: ResponsiveFontSizes.md,
              color: colorScheme.onSurfaceVariant,
            ),
        hintStyle: widget.hintStyle ??
            TextStyle(
              fontSize: ResponsiveFontSizes.md,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusSm),
              borderSide: BorderSide(
                color: colorScheme.outline,
              ),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusSm),
              borderSide: BorderSide(
                color: colorScheme.outline,
              ),
            ),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusSm),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2.r,
              ),
            ),
        errorBorder: widget.errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusSm),
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
        focusedErrorBorder: widget.focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusSm),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2.r,
              ),
            ),
        fillColor: widget.fillColor ?? colorScheme.surface,
        filled: widget.filled,
      ),
      validator: _validateConfirmPassword,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onSubmitted,
    );
  }
}
