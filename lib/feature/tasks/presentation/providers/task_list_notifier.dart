import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/task.dart';
import '../../data/repository/task_repository.dart';

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repo;

  TaskListNotifier(this._repo) : super(const AsyncValue.loading());

  Future<void> getTasksForDay(DateTime day) async {
    state = const AsyncLoading();
    final result = await _repo.getTasksForDay(day);

    state = result.fold(
      (l) => AsyncError(l, StackTrace.current),
      (r) {
        r.sort((a, b) => b.date.compareTo(a.date)); // optional
        return AsyncData(r);
      },
    );
  }

  Future<void> getTasksInRange({
    required DateTime start,
    required DateTime end,
    Filter filter = Filter.active,
  }) async {
    state = const AsyncLoading();
    final result = await _repo.getTasksInRange(start, end, filter: filter);

    state = result.fold(
      (l) => AsyncError(l, StackTrace.current),
      (r) => AsyncData(r),
    );
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>(
  (ref) => TaskListNotifier(ref.watch(taskRepositoryProvider)),
);
