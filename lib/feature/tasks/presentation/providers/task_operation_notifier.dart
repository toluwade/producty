import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/task.dart';
import '../../data/repository/task_repository.dart';

class TaskOperationNotifier extends StateNotifier<AsyncValue<Task?>> {
  final TaskRepository _repo;

  TaskOperationNotifier(this._repo) : super(const AsyncData(null));

  Future<void> createTask(Task task) async {
    state = const AsyncLoading();
    final result = await _repo.createTask(task);

    state = result.fold(
      (l) => AsyncError(l, StackTrace.current),
      (r) => AsyncData(r),
    );
  }

// You can add softDeleteTask, updateTask, etc., similarly.
}

final taskOperationProvider =
    StateNotifierProvider<TaskOperationNotifier, AsyncValue<Task?>>(
  (ref) => TaskOperationNotifier(ref.watch(taskRepositoryProvider)),
);
