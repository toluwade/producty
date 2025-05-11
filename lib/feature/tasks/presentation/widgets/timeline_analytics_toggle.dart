import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart' show Iconsax;

class TimelineAnalyticsToggle extends StatelessWidget {
  final bool isAnalyticsMode;
  final VoidCallback onTimelineSelected;
  final VoidCallback onAnalyticsSelected;
  final AnimationController animationController;
  final bool isDarkMode;

  const TimelineAnalyticsToggle({
    Key? key,
    required this.isAnalyticsMode,
    required this.onTimelineSelected,
    required this.onAnalyticsSelected,
    required this.animationController,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.h,
      width: 158.w,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe right
            if (isAnalyticsMode) {
              HapticFeedback.lightImpact();
              onTimelineSelected();
              animationController.reverse();
            }
          } else if (details.primaryVelocity! < 0) {
            // Swipe left
            if (!isAnalyticsMode) {
              HapticFeedback.lightImpact();
              onAnalyticsSelected();
              animationController.forward();
            }
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCirc,
              left: isAnalyticsMode ? 64.w : 1.w,
              right: isAnalyticsMode ? 1.w : 68.w,
              top: 3.h,
              bottom: 3.h,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB4F481),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTimelineSelected();
                    animationController.reverse();
                  },
                  child: Row(
                    children: [
                      if (!isAnalyticsMode)
                        Icon(
                          Iconsax.clock,
                          size: 16.sp,
                          color: Colors.black,
                        ),
                      if (!isAnalyticsMode) SizedBox(width: 4.w),
                      Text(
                        'Timeline',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w500,
                          color: !isAnalyticsMode
                              ? Colors.black
                              : (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onAnalyticsSelected();
                    animationController.forward();
                  },
                  child: Row(
                    children: [
                      if (isAnalyticsMode)
                        Icon(
                          Iconsax.chart_2,
                          size: 16.sp,
                          color: Colors.black,
                        ),
                      if (isAnalyticsMode) SizedBox(width: 4.w),
                      Text(
                        'Analytics',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isAnalyticsMode
                              ? Colors.black
                              : (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
