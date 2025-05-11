import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart' show Iconsax;

import 'timeline_analytics_toggle.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final String currentMonthYear;
  final AnimationController calendarAnimationController;
  final AnimationController toggleAnimationController;
  final VoidCallback onCalendarTap;
  final VoidCallback onTimelineSelected;
  final VoidCallback onAnalyticsSelected;
  final VoidCallback onProfileTap;
  final bool isAnalyticsMode;

  const DashboardAppBar({
    Key? key,
    required this.isDarkMode,
    required this.currentMonthYear,
    required this.calendarAnimationController,
    required this.toggleAnimationController,
    required this.onCalendarTap,
    required this.onTimelineSelected,
    required this.onAnalyticsSelected,
    required this.onProfileTap,
    required this.isAnalyticsMode,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onCalendarTap,
            child: Container(
              height: 35.h,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Iconsax.calendar,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF3D3D3D),
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      currentMonthYear,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF3D3D3D),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5)
                          .animate(calendarAnimationController),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF3D3D3D),
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TimelineAnalyticsToggle(
            isAnalyticsMode: isAnalyticsMode,
            isDarkMode: isDarkMode,
            animationController: toggleAnimationController,
            onTimelineSelected: onTimelineSelected,
            onAnalyticsSelected: onAnalyticsSelected,
          ),
          Container(
            width: 34.w,
            height: 34.h,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF2C2C2C)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Iconsax.user,
                  color: isDarkMode ? Colors.white : const Color(0xFF3D3D3D),
                  size: 20.sp,
                ),
                onPressed: onProfileTap,
                tooltip: 'Profile',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
