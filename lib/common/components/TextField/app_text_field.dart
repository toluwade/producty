import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/colors.dart';
import '../../style/component_style.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final String? error;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final IconData? icon;
  final int? maxLines;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? textColor;
  final bool obscureText;
  final String? Function(String?)? validator; // Added validator parameter

  const AppTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.error,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.icon,
    this.maxLines = 1,
    this.onTap,
    this.focusNode,
    this.fillColor,
    this.textColor,
    this.obscureText = false,
    this.validator, // Added validator
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultFillColor =
        isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF3F3F3);
    final defaultTextColor = isDark ? AppColors.darkText : AppColors.text;
    final defaultIconColor = isDark
        ? (_isFocused ? const Color(0xFFFFFFFF) : const Color(0xFF7B7B80))
        : AppColors.text.withValues(alpha: _isFocused ? 1 : 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: widget.textColor ?? defaultTextColor,
          ),
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor ?? defaultFillColor,
            hintText: widget.placeholder,
            hintStyle: GoogleFonts.dmSans(
              fontSize: 16,
              color: isDark
                  ? const Color(0xFF7B7B80)
                  : (widget.textColor ?? defaultTextColor)
                      .withValues(alpha: 0.5),
            ),
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: widget.error != null
                        ? (isDark ? AppColors.darkError : AppColors.error)
                        : defaultIconColor,
                  )
                : null,
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder.copyWith(
              borderSide: const BorderSide(width: 1),
            ),
            focusedErrorBorder: inputBorder.copyWith(
              borderSide: BorderSide(
                width: 1.5,
                color: isDark ? AppColors.darkError : AppColors.error,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
