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
import 'task_tile.dart';

class DailyRoutineWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime)? onDateChanged;

  const DailyRoutineWidget({
    Key? key,
    required this.selectedDate,
    this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use Consumer to listen to DailyRoutineProvider
    return Consumer<DailyRoutineProvider>(
      builder: (context, routineProvider, child) {
        // Get entries for the selected date
        final displayEntries = routineProvider.getEntriesForDate(selectedDate);

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;

            // Determine swipe direction
            if (details.primaryVelocity! > 0) {
              // Swiped right - go to previous day
              final newDate = selectedDate.subtract(const Duration(days: 1));
              onDateChanged?.call(newDate);
            } else if (details.primaryVelocity! < 0) {
              // Swiped left - go to next day
              final newDate = selectedDate.add(const Duration(days: 1));
              onDateChanged?.call(newDate);
            }
          },
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: EdgeInsets.only(
                top: 10.h, left: 16.w, right: 16.w, bottom: 22.h),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF28282A)
                  : Theme.of(context).cardColor,
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
                      _getDateHeader(selectedDate),
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
                                'No tasks for this day',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: displayEntries.length,
                              proxyDecorator: (child, index, animation) {
                                final isDarkMode =
                                    Theme.of(context).brightness ==
                                        Brightness.dark;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? const Color(0xFF28282A)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: child,
                                );
                              },
                              onReorder: (oldIndex, newIndex) {
                                var newItemIndex = newIndex;
                                if (oldIndex < newIndex) {
                                  newItemIndex--;
                                }

                                // Update the provider
                                Provider.of<DailyRoutineProvider>(context,
                                        listen: false)
                                    .reorderEntries(
                                        selectedDate, oldIndex, newItemIndex);
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  key: ValueKey('entry_$index'),
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: TaskTile(
                                    entry: displayEntries[index],
                                    onTap: () {
                                      Provider.of<DailyRoutineProvider>(context,
                                              listen: false)
                                          .toggleEntryCompletionForDate(
                                              selectedDate,
                                              displayEntries[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                    SizedBox(height: 60.h), // Space for the button
                  ],
                ),
                // Add New Task button at the bottom
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
          ),
        );
      },
    );
  }

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    if (_isSameDay(date, now)) {
      return 'Today';
    } else if (_isSameDay(date, yesterday)) {
      return 'Yesterday';
    } else if (_isSameDay(date, tomorrow)) {
      return 'Tomorrow';
    } else {
      // Format as "Friday, Jan 24"
      return '${_getDayName(date.weekday)}, ${_getMonthName(date.month)} ${date.day}';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  void _showAddRoutineBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRoutineScreen(
        onRoutineAdded: (newEntry) {
          _saveRoutineEntry(context, newEntry);
        },
        selectedDate: selectedDate,
      ),
    );
  }

  void _saveRoutineEntry(BuildContext context, DailyRoutineEntry newEntry) {
    final routineService = DailyRoutineService();
    final parsedTime = _parseTime(newEntry.time);

    final task = DailyRoutineTask(
      id: const uuid.Uuid().v4(),
      title: newEntry.title,
      description: newEntry.description,
      startTime: parsedTime,
    );

    // Save the task for the selected date
    routineService.saveTaskForDate(selectedDate, task);

    // Update the UI through the provider
    try {
      Provider.of<DailyRoutineProvider>(context, listen: false)
          .addRoutineEntryForDate(selectedDate, newEntry);
    } catch (e) {
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
}
