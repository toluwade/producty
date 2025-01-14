import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_bottom_sheet.dart';

class ThemeSettingsSheet extends StatelessWidget {
  const ThemeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CustomBottomSheet(
      title: 'Theme Settings',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildThemeOption(
            context,
            'System',
            Iconsax.mobile,
            themeProvider.themeMode == ThemeMode.system,
            () => themeProvider.setThemeMode(ThemeMode.system),
            isDarkMode,
          ),
          _buildThemeOption(
            context,
            'Light',
            Iconsax.sun_1,
            themeProvider.themeMode == ThemeMode.light,
            () => themeProvider.setThemeMode(ThemeMode.light),
            isDarkMode,
          ),
          _buildThemeOption(
            context,
            'Dark',
            Iconsax.moon,
            themeProvider.themeMode == ThemeMode.dark,
            () => themeProvider.setThemeMode(ThemeMode.dark),
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
              ? const Color(0xFFACF75F).withOpacity(0.15)
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
