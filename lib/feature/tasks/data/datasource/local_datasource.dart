import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/task.dart';

abstract class TasksLocalDataSource {
  Future<void> saveTask(Task task);
  Future<List<Task>> getUnsyncedTasks();
  Future<void> markTaskAsSynced(String taskId);
  Stream<List<Task>> streamTasks();
  Future<List<Task>> getTasksInRange(
      DateTime start, DateTime end, Filter filter);
  Future<DateTimeRange?> getCachedRange(); // <- Add this
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  final Box<Task> taskBox;

  TasksLocalDataSourceImpl(Ref ref) : taskBox = ref.read(taskBoxProvider);

  @override
  Future<void> saveTask(Task task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<List<Task>> getUnsyncedTasks() async {
    return taskBox.values.where((task) => !task.isSynced).toList();
  }

  @override
  Future<void> markTaskAsSynced(String taskId) async {
    final task = taskBox.get(taskId);
    if (task != null) {
      await taskBox.put(taskId, task.copyWith(isSynced: true));
    }
  }

  @override
  Stream<List<Task>> streamTasks() async* {
    yield* taskBox.watch().map((event) => taskBox.values.toList());
  }

  @override
  Future<DateTimeRange?> getCachedRange() async {
    if (taskBox.isEmpty) return null;

    final allDates = taskBox.values.map((task) => task.date).toList();

    final minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
    final maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);

    return DateTimeRange(start: minDate, end: maxDate);
  }

  @override
  Future<List<Task>> getTasksInRange(
      DateTime start, DateTime end, Filter filter) async {
    // Fetch tasks that fall within the date range
    final tasksInRange = taskBox.values.where((task) {
      return task.date.isAfter(start) && task.date.isBefore(end);
    }).toList();

    // Apply the filter (e.g., active, completed)
    switch (filter) {
      case Filter.active:
        return tasksInRange.where((task) => !task.isCompleted).toList();
      case Filter.deleted:
        return tasksInRange.where((task) => task.isDeleted).toList();
      case Filter.all:
        return tasksInRange;
    }
  }
}

final taskBoxProvider = Provider<Box<Task>>((ref) {
  throw UnimplementedError();
});

final tasksLocalDataSourceProvider = Provider<TasksLocalDataSource>(
  (ref) => TasksLocalDataSourceImpl(ref),
);
