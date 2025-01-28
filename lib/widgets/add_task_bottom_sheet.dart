import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AddTaskBottomSheet extends StatelessWidget {
  final VoidCallback onAddTask;

  const AddTaskBottomSheet({
    super.key,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: onAddTask,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50.h),
        backgroundColor:
            isDarkMode ? const Color(0xFF3D3D3D) : const Color(0xFF3D3D3D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.add,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Add New Task',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
