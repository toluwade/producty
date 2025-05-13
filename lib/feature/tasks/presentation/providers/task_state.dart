import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:producty/core/failures/failures.dart';
import 'package:producty/feature/tasks/data/model/task.dart';

part 'task_state.freezed.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.initial() = TaskInitial;

  const factory TaskState.operationState({
    required TaskOperation operation,
    required TaskStatus status,
    List<Task>? tasks,
    Task? task,
    Failure? failure,
    DateTimeRange? loadedDateRange,
  }) = TaskOperationState;
}

enum TaskOperation {
  fetchTasks,
  createTask,
  updateTask,
  deleteTask,
}

enum TaskStatus {
  loading,
  success,
  failure,
}
