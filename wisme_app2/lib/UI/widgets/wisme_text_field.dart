import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

/// Modern, accessible text field component for Wisme app
/// High contrast, clear labels, proper validation feedback
class WismeTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final void Function()? onEditingComplete;

  const WismeTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
  });

  @override
  State<WismeTextField> createState() => _WismeTextFieldState();
}

class _WismeTextFieldState extends State<WismeTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        _buildLabel(),
        const SizedBox(height: AppSpacing.xs),
        
        // Input Field
        _buildInputField(hasError),
        
        // Helper/Error Text
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildHelperText(hasError),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.label,
            style: AppTextStyles.labelLarge.copyWith(
              color: widget.enabled ? AppColors.textPrimary : AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.required)
            TextSpan(
              text: ' *',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField(bool hasError) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(
          color: _getBorderColor(hasError),
          width: _getBorderWidth(hasError),
        ),
        color: widget.enabled 
            ? AppColors.surface 
            : AppColors.backgroundTertiary,
        boxShadow: _hasFocus && !hasError ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        obscureText: _obscureText,
        autofocus: widget.autofocus,
        maxLines: _obscureText ? 1 : widget.maxLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        onEditingComplete: widget.onEditingComplete,
        style: AppTextStyles.bodyLarge.copyWith(
          color: widget.enabled 
              ? AppColors.textPrimary 
              : AppColors.textTertiary,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: _buildSuffixIcon(),
          prefixText: widget.prefixText,
          suffixText: widget.suffixText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          border: InputBorder.none,
          counterText: '', // Hide default counter
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      );
    }
    return widget.suffixIcon;
  }

  Widget _buildHelperText(bool hasError) {
    final text = hasError ? widget.errorText! : widget.helperText!;
    final color = hasError ? AppColors.error : AppColors.textSecondary;
    
    return Row(
      children: [
        if (hasError) ...[
          Icon(
            Icons.error_outline,
            size: 16,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Color _getBorderColor(bool hasError) {
    if (!widget.enabled) {
      return AppColors.borderSubtle;
    }
    if (hasError) {
      return AppColors.error;
    }
    if (_hasFocus) {
      return AppColors.primary;
    }
    return AppColors.border;
  }

  double _getBorderWidth(bool hasError) {
    if (_hasFocus || hasError) {
      return 2;
    }
    return 1;
  }
}

/// Search input field with built-in search functionality
class WismeSearchField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;

  const WismeSearchField({
    super.key,
    this.hint,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return WismeTextField(
      label: 'Search',
      hint: hint ?? 'Search...',
      controller: controller,
      focusNode: focusNode,
      prefixIcon: const Icon(
        Icons.search,
        color: AppColors.textSecondary,
      ),
      suffixIcon: _buildSuffixIcon(),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      enabled: enabled,
      textInputAction: TextInputAction.search,
    );
  }

  Widget? _buildSuffixIcon() {
    if (controller?.text.isNotEmpty == true) {
      return IconButton(
        icon: const Icon(
          Icons.clear,
          color: AppColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          controller?.clear();
          onClear?.call();
        },
        tooltip: 'Clear search',
      );
    }
    return null;
  }
}

/// Text area for longer text input
class WismeTextArea extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool required;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const WismeTextArea({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.required = false,
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return WismeTextField(
      label: label,
      hint: hint,
      errorText: errorText,
      helperText: helperText,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      required: required,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }
}
