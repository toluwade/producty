import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:producty/utils/extensions/date_time.dart';

import '../feature/tasks/data/model/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskTile({
    Key? key,
    required this.task,
    this.onTap,
  }) : super(key: key);

  // IconData _getTaskIcon() {
  //   if (task.date.contains('8:00 AM')) {
  //     return Iconsax.alarm;
  //   } else if (entry.time.contains('9:00 AM')) {
  //     return Iconsax.coffee;
  //   } else if (entry.time.contains('10:00 AM')) {
  //     return Iconsax.briefcase;
  //   } else {
  //     return Iconsax.clock;
  //   }
  // }
  //
  // Color _getIconColor() {
  //   if (entry.time.contains('8:00 AM')) {
  //     return Colors.green;
  //   } else if (entry.time.contains('9:00 AM')) {
  //     return Colors.orange;
  //   } else if (entry.time.contains('10:00 AM')) {
  //     return Colors.blue;
  //   } else {
  //     return Colors.grey.shade600;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              // Container(
              //   width: 32.h,
              //   height: 32.h,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: _getIconColor().withOpacity(0.1),
              //     border: Border.all(
              //       color: _getIconColor(),
              //       width: 1.5.w,
              //     ),
              //   ),
              //   child: Center(
              //     child: Icon(
              //       _getTaskIcon(),
              //       size: 16.sp,
              //       color: _getIconColor(),
              //     ),
              //   ),
              // ),
              SizedBox(width: 16.w),

              // Task Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.date.toReadableTime(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (task.otherDetails != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        task.otherDetails!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Checkbox
              Container(
                width: 22.h,
                height: 22.h,
                margin: EdgeInsets.only(left: 12.w, top: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: task.isCompleted
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    width: 1.5.w,
                  ),
                  color: task.isCompleted
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                child: task.isCompleted
                    ? Icon(
                        Icons.check,
                        size: 16.sp,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
