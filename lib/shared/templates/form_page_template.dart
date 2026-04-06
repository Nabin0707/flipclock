import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/primary_button.dart';
import 'package:flutter_clean_architecture/shared/widgets/buttons/outline_button.dart';

// TODO: Add form validation and error handling
/// Template for creating form pages with validation and submission
/// Use this for create/edit forms across features
class FormPageTemplate extends StatefulWidget {
  final String title;
  final List<FormFieldConfig> fields;
  final Future<void> Function(Map<String, dynamic> data)? onSubmit;
  final VoidCallback? onCancel;
  final String submitButtonText;
  final String? cancelButtonText;
  final Map<String, dynamic>? initialData;
  final bool showCancelButton;

  const FormPageTemplate({
    super.key,
    required this.title,
    required this.fields,
    this.onSubmit,
    this.onCancel,
    this.submitButtonText = 'Submit',
    this.cancelButtonText,
    this.initialData,
    this.showCancelButton = true,
  });

  @override
  State<FormPageTemplate> createState() => _FormPageTemplateState();
}

class _FormPageTemplateState extends State<FormPageTemplate> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _controllers[field.key] = TextEditingController(
        text: widget.initialData?[field.key]?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.onSubmit == null) return;

    setState(() => _isSubmitting = true);

    try {
      final data = <String, dynamic>{};
      for (var entry in _controllers.entries) {
        data[entry.key] = entry.value.text;
      }

      await widget.onSubmit!(data);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...widget.fields.map((field) => _buildField(field)),
            const SizedBox(height: 32),
            Row(
              children: [
                if (widget.showCancelButton) ...[
                  Expanded(
                    child: OutlineButton(
                      text: widget.cancelButtonText ?? 'Cancel',
                      onPressed:
                          widget.onCancel ?? () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: widget.showCancelButton ? 1 : 2,
                  child: PrimaryButton(
                    text: widget.submitButtonText,
                    onPressed: _handleSubmit,
                    isLoading: _isSubmitting,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(FormFieldConfig field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _controllers[field.key],
        decoration: InputDecoration(
          labelText: field.label,
          hintText: field.hint,
          prefixIcon: field.icon != null ? Icon(field.icon) : null,
          border: const OutlineInputBorder(),
        ),
        keyboardType: field.keyboardType,
        obscureText: field.obscureText,
        maxLines: field.maxLines,
        validator: (value) {
          if (field.required && (value == null || value.isEmpty)) {
            return '${field.label} is required';
          }
          if (field.validator != null) {
            return field.validator!(value);
          }
          return null;
        },
      ),
    );
  }
}

class FormFieldConfig {
  final String key;
  final String label;
  final String? hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final bool required;
  final String? Function(String?)? validator;

  FormFieldConfig({
    required this.key,
    required this.label,
    this.hint,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.required = false,
    this.validator,
  });
}
