import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:producty/feature/tasks/presentation/providers/task_state.dart';

import '../../data/model/task.dart';
import '../../data/repository/task_repository.dart';

class TaskStateNotifier extends StateNotifier<TaskState> {
  final TaskRepository _taskRepository;

  TaskStateNotifier(Ref ref)
      : _taskRepository = ref.read(taskRepositoryProvider),
        super(const TaskInitial());

  // Fetch tasks within a date range and filter
  Future<void> getTasksInRange({
    required DateTime start,
    required DateTime end,
    Filter filter = Filter.active,
  }) async {
    state = const TaskOperationState(
      operation: TaskOperation.fetchTasks,
      status: TaskStatus.loading,
    );

    final result =
        await _taskRepository.getTasksInRange(start, end, filter: filter);

    result.fold(
      (l) => state = TaskOperationState(
        operation: TaskOperation.fetchTasks,
        status: TaskStatus.failure,
        failure: l,
      ),
      (r) => state = TaskOperationState(
        operation: TaskOperation.fetchTasks,
        status: TaskStatus.success,
        tasks: r,
        loadedDateRange: DateTimeRange(start: start, end: end),
      ),
    );
  }

  Future<void> getTasksForDay(DateTime day) async {
    state = const TaskOperationState(
      operation: TaskOperation.fetchTasks,
      status: TaskStatus.loading,
    );

    final result = await _taskRepository.getTasksForDay(day);

    result.fold(
      (l) => state = TaskOperationState(
        operation: TaskOperation.fetchTasks,
        status: TaskStatus.failure,
        failure: l,
      ),
      (r) => state = TaskOperationState(
        operation: TaskOperation.fetchTasks,
        status: TaskStatus.success,
        tasks: r,
      ),
    );
  }

  // Create a new task
  Future<void> createTask(Task task) async {
    state = const TaskOperationState(
      operation: TaskOperation.createTask,
      status: TaskStatus.loading,
    );

    final result = await _taskRepository.createTask(task);

    state = result.fold(
      (l) => TaskOperationState(
        operation: TaskOperation.createTask,
        status: TaskStatus.failure,
        failure: l,
      ),
      (r) => TaskOperationState(
        operation: TaskOperation.createTask,
        status: TaskStatus.success,
        task: r,
      ),
    );
  }
// Add more methods like softDelete, hardDelete, etc., if needed.

  //
  // Future<void> hardDeleteTask(String id) async {
  //   state = const TaskState.hardDeleteLoading();
  //
  //   final result = await _taskRepository.hardDeleteTask(id);
  //
  //   state = result.fold(
  //     (l) => TaskHardDeleteFailure(l),
  //     (r) => TaskHardDeleteSuccess(r),
  //   );
  // }
  //
  // Future<void> softDeleteTask(String id) async {
  //   state = const TaskSoftDeleteLoading();
  //
  //   final result = await _taskRepository.softDeleteTask(id);
  //
  //   state = result.fold(
  //     (l) => TaskSoftDeleteFailure(l),
  //     (r) => TaskSoftDeleteSuccess(r),
  //   );
  // }
}

final taskStateNotifierProvider =
    StateNotifierProvider<TaskStateNotifier, TaskState>(
  (ref) => TaskStateNotifier(ref),
);
