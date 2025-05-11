import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../config/theme/theme_provider.dart';
import 'custom_bottom_sheet.dart';

class ThemeSettingsSheet extends ConsumerWidget {
  const ThemeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return CustomBottomSheet(
      title: 'Theme Settings',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context,
            'System',
            Iconsax.mobile,
            themeMode == ThemeMode.system,
            () => themeNotifier.setThemeMode(ThemeMode.system),
            isDarkMode,
          ),
          _buildThemeOption(
            context,
            'Light',
            Iconsax.sun_1,
            themeMode == ThemeMode.light,
            () => themeNotifier.setThemeMode(ThemeMode.light),
            isDarkMode,
          ),
          _buildThemeOption(
            context,
            'Dark',
            Iconsax.moon,
            themeMode == ThemeMode.dark,
            () => themeNotifier.setThemeMode(ThemeMode.dark),
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    final Color textAndIconColor = isDarkMode
        ? (isSelected ? const Color(0xFFACF75F) : Colors.white)
        : const Color(0xFF3D3D3D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFACF75F).withValues(alpha: 0.15)
              : (isDarkMode ? Colors.transparent : const Color(0xFFF3F3F3)),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFACF75F) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: textAndIconColor,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: textAndIconColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: isDarkMode
                    ? const Color(0xFFACF75F)
                    : const Color(0xFF3D3D3D),
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
