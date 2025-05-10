import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:producty/common/components/Loader/loading_indicator.dart';

import '../../../core/constants/colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color? color;
  final Color? labelColor;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.color,
    this.labelColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor =
        color ?? (isDark ? AppColors.darkPrimary : AppColors.primary);
    final textColor =
        labelColor ?? (isDark ? AppColors.darkText : AppColors.white);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return buttonColor.withValues(alpha: 0.85);
            }
            return buttonColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return textColor;
            }
            return textColor;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: isLoading
            ? const LoadingIndicator(size: 30)
            : Text(
                text,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
