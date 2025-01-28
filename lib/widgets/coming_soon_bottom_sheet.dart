import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'custom_button.dart';

class ComingSoonBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onClose;
  final Color accentColor;

  const ComingSoonBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onClose,
    this.accentColor = const Color(0xFFB4F481),
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
        ),
        constraints: BoxConstraints(
          maxWidth: 0.9.sw,
          minHeight: 0.25.sh,
          maxHeight: 0.9.sh,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 200.w,
                        height: 200.h,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            isDarkMode ? accentColor : const Color(0xFF3D3D3D),
                            BlendMode.srcATop,
                          ),
                          child: Lottie.asset(
                            'assets/animations/comingsoon.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                height: 22.h,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? Colors.grey[800]
                                      : const Color(0xFFACF75F),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.chart_2,
                                      size: 14.sp,
                                      color: isDarkMode
                                          ? accentColor
                                          : const Color(0xFF3D3D3D),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Analytics',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextSpan(
                              text: ' is Coming Soon!',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Text(
                            'Take your productivity to the next level!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[800]!.withOpacity(0.5)
                                  : Colors.grey[200]!.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BulletPoint(
                                  text:
                                      'Track your streaks and build winning habits.',
                                  isDarkMode: isDarkMode,
                                ),
                                SizedBox(height: 12.h),
                                BulletPoint(
                                  text:
                                      'Explore weekly heatmaps to identify peak performance periods.',
                                  isDarkMode: isDarkMode,
                                ),
                                SizedBox(height: 12.h),
                                BulletPoint(
                                  text:
                                      'View detailed statistics and uncover insights into your daily routines.',
                                  isDarkMode: isDarkMode,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Get ready to visualize your progress like never before!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? accentColor
                                  : const Color(0xFF3D3D3D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GestureDetector(
                        onTap: onClose,
                        child: Container(
                          width: double.infinity,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? accentColor
                                : const Color(0xFF3D3D3D),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  final bool isDarkMode;

  const BulletPoint({
    super.key,
    required this.text,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode
                ? const Color(0xFFACF75F).withOpacity(0.2)
                : const Color(0xFFACF75F),
          ),
          child: Center(
            child: Icon(
              Icons.check_rounded,
              size: 12.sp,
              color: isDarkMode ? const Color(0xFFACF75F) : Colors.black,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
