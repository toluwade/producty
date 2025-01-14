import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? checkColor;
  final String? label;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.checkColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = checkColor ?? (isDark ? AppColors.darkPrimary : AppColors.primary);
    
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value ? activeColor : (isDark ? AppColors.darkGrey : Colors.grey[400]!),
              ),
            ),
            child: value
                ? Icon(
                    Iconsax.tick_square,
                    size: 12,
                    color: isDark ? AppColors.darkText : AppColors.white,
                  )
                : null,
          ),
          if (label != null) ...[
            const SizedBox(width: 8),
            Text(
              label!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.darkText : Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
