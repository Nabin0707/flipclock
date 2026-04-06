import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_clean_architecture/core/utils/responsive_utils.dart';

// TODO: Add biometric authentication option if needed
/// Password text field with show/hide toggle
/// Includes validation for password strength
/// Uses responsive sizing with flutter_screenutil
class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool showStrengthIndicator;

  const PasswordTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.showStrengthIndicator = false,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  PasswordStrength _passwordStrength = PasswordStrength.none;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _checkPasswordStrength(String password) {
    if (!widget.showStrengthIndicator) return;

    setState(() {
      if (password.isEmpty) {
        _passwordStrength = PasswordStrength.none;
      } else if (password.length < 6) {
        _passwordStrength = PasswordStrength.weak;
      } else if (password.length < 8) {
        _passwordStrength = PasswordStrength.medium;
      } else if (_hasUpperCase(password) &&
          _hasLowerCase(password) &&
          _hasDigits(password) &&
          _hasSpecialCharacters(password)) {
        _passwordStrength = PasswordStrength.strong;
      } else {
        _passwordStrength = PasswordStrength.medium;
      }
    });
  }

  bool _hasUpperCase(String password) => password.contains(RegExp(r'[A-Z]'));
  bool _hasLowerCase(String password) => password.contains(RegExp(r'[a-z]'));
  bool _hasDigits(String password) => password.contains(RegExp(r'[0-9]'));
  bool _hasSpecialCharacters(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          onChanged: (value) {
            _checkPasswordStrength(value);
            widget.onChanged?.call(value);
          },
          validator: widget.validator ?? _defaultValidator,
          decoration: InputDecoration(
            labelText: widget.labelText ?? 'Password',
            hintText: widget.hintText ?? 'Enter your password',
            prefixIcon: Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),
        ),
        if (widget.showStrengthIndicator &&
            _passwordStrength != PasswordStrength.none)
          Padding(
            padding: ResponsiveSpacing.only(top: 8.r),
            child: _PasswordStrengthIndicator(strength: _passwordStrength),
          ),
      ],
    );
  }
}

/// Confirm password text field with matching validation
class ConfirmPasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextEditingController? passwordController;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const ConfirmPasswordTextField({
    super.key,
    this.controller,
    required this.passwordController,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<ConfirmPasswordTextField> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<ConfirmPasswordTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController?.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      onChanged: widget.onChanged,
      validator: _validator,
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Confirm Password',
        hintText: widget.hintText ?? 'Re-enter your password',
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }
}

enum PasswordStrength { none, weak, medium, strong }

class _PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const _PasswordStrengthIndicator({required this.strength});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    Color color;
    String text;
    double progress;

    switch (strength) {
      case PasswordStrength.weak:
        color = colorScheme.error;
        text = 'Weak';
        progress = 0.33;
        break;
      case PasswordStrength.medium:
        color = const Color(0xFFF59E0B); // Warning color
        text = 'Medium';
        progress = 0.66;
        break;
      case PasswordStrength.strong:
        color = const Color(0xFF10B981); // Success color
        text = 'Strong';
        progress = 1.0;
        break;
      case PasswordStrength.none:
        color = theme.dividerColor;
        text = '';
        progress = 0.0;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveSpacing.radiusXs),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4.r,
                ),
              ),
            ),
            SizedBox(width: 8.r),
            Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveFontSizes.sm,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
