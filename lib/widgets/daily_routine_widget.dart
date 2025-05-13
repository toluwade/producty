import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:producty/common/components/index.dart';
import 'package:producty/feature/tasks/presentation/providers/task_state.dart';

import '../feature/tasks/data/model/task.dart';
import '../feature/tasks/presentation/providers/task_notifier.dart';
import 'task_tile.dart';

class DailyRoutineWidget extends ConsumerWidget {
  final DateTime selectedDate;
  final Function(DateTime)? onDateChanged;

  const DailyRoutineWidget({
    Key? key,
    required this.selectedDate,
    this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final taskState = ref.watch(taskStateNotifierProvider);
    final isLoading = taskState is TaskOperationState &&
        taskState.status == TaskStatus.loading;

    final isSuccess = taskState is TaskOperationState &&
        taskState.status == TaskStatus.success;

    List<Task> displayEntries = [];

    if (isSuccess && taskState.tasks != null) {
      displayEntries = taskState.tasks!;
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

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
        padding:
            EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 22.h),
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
                if (isLoading)
                  const LoadingIndicator()
                else if (isSuccess)
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
                              final isDarkMode = Theme.of(context).brightness ==
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

                              // // Update the provider
                              // ref
                              //   .read(taskStateNotifierProvider.notifier)
                              //   .reorderTasks(selectedDate, oldIndex, newItemIndex);
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                key: ValueKey('entry_$index'),
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: TaskTile(
                                  task: displayEntries[index],
                                  onTap: () {
                                    // ref
                                    //   .read(taskStateNotifierProvider.notifier)
                                    //   .toggleTaskCompletion(selectedDate, displayEntries[index]);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
              ],
            ),
          ],
        ),
      ),
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

  DateTime? _parseTime(String timeString) {
    try {
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
        minute,
      );
    } catch (_) {
      return null;
    }
  }
}
