import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../services/daily_routine_service.dart';
import '../providers/daily_routine_provider.dart';
import '../models/daily_routine_entry.dart';
import '../models/daily_routine_model.dart';
import '../screens/daily_routine/add_routine_screen.dart';

class DailyRoutineWidget extends StatelessWidget {
  final List<DailyRoutineEntry> entries;

  const DailyRoutineWidget({Key? key, this.entries = const []})
      : super(key: key);

  void _showAddRoutineBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRoutineScreen(
        onRoutineAdded: (newEntry) {
          // Save the routine entry using the new service
          _saveRoutineEntry(context, newEntry);
        },
      ),
    );
  }

  void _saveRoutineEntry(BuildContext context, DailyRoutineEntry newEntry) {
    // Convert DailyRoutineEntry to DailyRoutineTask
    final routineService = DailyRoutineService();

    // Safely handle time parsing
    final parsedTime = _parseTime(newEntry.time);

    final task = DailyRoutineTask(
      id: const uuid.Uuid().v4(),
      title: newEntry.title,
      description: newEntry.description,
      startTime: parsedTime,
    );

    // Save the task for today's date
    routineService.saveTaskForDate(DateTime.now(), task);

    // Also add to the provider for immediate UI update
    try {
      Provider.of<DailyRoutineProvider>(context, listen: false)
          .addRoutineEntry(newEntry);
    } catch (e) {
      // Fallback if provider is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to add routine: $e')),
      );
    }
    Navigator.of(context).pop();
  }

  // Helper method to parse time string to DateTime
  DateTime? _parseTime(String timeString) {
    try {
      // Assuming time format is like "9:00 AM"
      final now = DateTime.now();
      final timeParts = timeString.split(':');
      final hour = int.parse(timeParts[0]);
      final minuteParts = timeParts[1].split(' ');
      final minute = int.parse(minuteParts[0]);
      final isPM = minuteParts[1] == 'PM';

      return DateTime(
          now.year,
          now.month,
          now.day,
          isPM ? (hour == 12 ? 12 : hour + 12) : (hour == 12 ? 0 : hour),
          minute);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Try to get the provider, use initial entries as fallback
    List<DailyRoutineEntry> displayEntries;
    try {
      final entriesProvider = Provider.of<DailyRoutineProvider>(context);

      // Add initial entries to the provider if not already present
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var entry in entries) {
          if (!entriesProvider.entries.contains(entry)) {
            entriesProvider.addRoutineEntry(entry);
          }
        }
      });

      displayEntries = entriesProvider.entries;
    } catch (e) {
      // Fallback to initial entries if provider is not found
      displayEntries =
          entries.isEmpty ? DailyRoutineEntry.defaultEntries : entries;
    }

    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      padding:
          EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 22.h),
      decoration: BoxDecoration(
        color:
            isDarkMode ? const Color(0xFF28282A) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal handle bar
              Center(
                child: Container(
                  width: 69.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF3D3D3D)
                        : const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Text(
                'Today',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
              ),
              SizedBox(height: 12.h),
              displayEntries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          'No tasks for today',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                    )
                  : Column(
                      children: List.generate(
                        displayEntries.length * 2 - 1,
                        (index) {
                          if (index.isEven) {
                            // Routine entries
                            final entryIndex = index ~/ 2;
                            return _buildRoutineEntry(
                                context,
                                displayEntries[entryIndex],
                                entryIndex == displayEntries.length - 1);
                          } else {
                            // Connecting line
                            return _buildConnectingLine(context);
                          }
                        },
                      ),
                    ),
              SizedBox(height: 12.h),
            ],
          ),
          // Positioned Add New Task button at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ElevatedButton(
              onPressed: () => _showAddRoutineBottomSheet(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: isDarkMode
                    ? const Color(0xFF3D3D3D)
                    : const Color(0xFF3D3D3D),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingLine(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Center(
        child: Container(
          width: 2.w,
          height: 20.h,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildRoutineEntry(
      BuildContext context, DailyRoutineEntry entry, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24.h,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: entry.isCompleted
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
              child: Center(
                child: Icon(
                  entry.isCompleted ? Icons.check : Icons.circle,
                  size: 16.sp,
                  color:
                      entry.isCompleted ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              Text(
                entry.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                entry.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
