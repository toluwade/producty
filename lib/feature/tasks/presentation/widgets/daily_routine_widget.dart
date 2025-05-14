import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:producty/common/components/index.dart';
import 'package:producty/feature/tasks/presentation/extensions/string_extensions.dart';
import 'package:producty/feature/tasks/presentation/providers/task_list_notifier.dart';
import 'package:producty/feature/tasks/presentation/providers/task_operation_notifier.dart';

import '../../../../screens/daily_routine/add_routine_screen.dart';
import '../../../../widgets/task_tile.dart';
import 'add_task_sheet.dart';

class DailyRoutineWidget extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime)? onDateChanged;

  const DailyRoutineWidget({
    Key? key,
    required this.selectedDate,
    this.onDateChanged,
  }) : super(key: key);

  @override
  ConsumerState<DailyRoutineWidget> createState() => _DailyRoutineWidgetState();
}

class _DailyRoutineWidgetState extends ConsumerState<DailyRoutineWidget> {
  @override
  void initState() {
    super.initState();
    _fetchTasksForDay(widget.selectedDate);
  }

  @override
  void didUpdateWidget(covariant DailyRoutineWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _fetchTasksForDay(widget.selectedDate);
    }
  }

  void _fetchTasksForDay(DateTime date) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskListProvider.notifier).getTasksForDay(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! > 0) {
          // Swiped right - go to previous day
          final newDate = widget.selectedDate.subtract(const Duration(days: 1));
          widget.onDateChanged?.call(newDate);
        } else if (details.primaryVelocity! < 0) {
          // Swiped left - go to next day
          final newDate = widget.selectedDate.add(const Duration(days: 1));
          widget.onDateChanged?.call(newDate);
        }
      },
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding:
            EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w, bottom: 16.h),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF28282A)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .02),
              offset: const Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
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
              widget.selectedDate.getDateHeader(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: ref.watch(taskListProvider).when(
                    data: (tasks) => tasks.isEmpty
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
                        : ReorderableListView.builder(
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            proxyDecorator: (child, index, animation) {
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
                              final newItemIndex =
                                  oldIndex < newIndex ? newIndex - 1 : newIndex;
                              final task = tasks.removeAt(oldIndex);
                              tasks.insert(newItemIndex, task);
                              // Also update state or call notifier if needed
                            },
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Padding(
                                key: ValueKey('entry_$index'),
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: TaskTile(
                                  task: task,
                                  onTap: () {
                                    // Handle toggle or detail navigation
                                  },
                                ),
                              );
                            },
                          ),
                    error: (e, _) => Text('Error: $e'),
                    loading: () => LoadingIndicator(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
            ),
            AddTaskButton(
              onAddTask: () => _showAddRoutineBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  /*
     if (isLoading)
              const LoadingIndicator()
            else if (isSuccess)
              tasks.isEmpty
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
                  : ReorderableListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    proxyDecorator: (child, index, animation) {
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

                      // // Optional: handle reordering if needed
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        key: ValueKey('entry_$index'),
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: TaskTile(
                          task: tasks[index],
                          onTap: () {
                            // Optional: handle toggle completion
                          },
                        ),
                      );
                    },
                  ),
   */
  void _showAddRoutineBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRoutineSheet(
        onRoutineAdded: (newTask) {
          ref.read(taskOperationProvider.notifier).createTask(newTask);
          Navigator.pop(context);
        },
        selectedDate: widget.selectedDate,
      ),
    );
  }
}
