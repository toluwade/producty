import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

class CustomTextField extends StatefulWidget {
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

  const CustomTextField({
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
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
    final defaultFillColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF3F3F3);
    final defaultTextColor = isDark ? AppColors.darkText : AppColors.text;
    final defaultIconColor = isDark 
        ? (_isFocused ? const Color(0xFFFFFFFF) : const Color(0xFF7B7B80))
        : AppColors.text.withOpacity(_isFocused ? 1 : 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.fillColor ?? defaultFillColor,
            borderRadius: BorderRadius.circular(12),
            border: widget.error != null
                ? Border.all(
                    color: isDark ? AppColors.darkError : AppColors.error,
                    width: 1,
                  )
                : _isFocused
                    ? Border.all(
                        color: isDark 
                            ? const Color(0xFF3D3D3D)
                            : const Color(0xFFDEDEDE),
                        width: 1,
                      )
                    : null,
          ),
          child: TextField(
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
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: GoogleFonts.dmSans(
                fontSize: 16,
                color: isDark
                    ? const Color(0xFF7B7B80)
                    : (widget.textColor ?? defaultTextColor).withOpacity(0.5),
              ),
              prefixIcon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: widget.error != null
                          ? (isDark ? AppColors.darkError : AppColors.error)
                          : defaultIconColor,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (widget.error != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.error!,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: isDark ? AppColors.darkError : AppColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
