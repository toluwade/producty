import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:producty/core/constants/error_strings.dart';
import 'package:producty/utils/extensions/date_time.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/network/network.dart';
import '../../../../core/runner/service_runner.dart';
import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';
import '../model/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasksInRange(
    DateTime start,
    DateTime end, {
    Filter filter,
  });
  Future<Either<Failure, List<Task>>> getTasksForDay(
    DateTime day, {
    Filter filter,
  });
  Future<Either<Failure, Task>> createTask(Task task);
  Future<Either<Failure, String>> updateTask(
    String id,
    Map<String, dynamic> payload,
  );
  Future<Either<Failure, Task>> toggleTaskCompletion(String id);
  Future<Either<Failure, String>> softDeleteTask(String id);
  Future<Either<Failure, Task>> restoreTask(String id);
  Future<Either<Failure, String>> hardDeleteTask(String id);
}

class TaskRepositoryImpl implements TaskRepository {
  final NetworkInfo _networkInfo;
  final TasksRemoteDataSource _tasksRemoteDataSource;
  final TasksLocalDataSource _localDataSource;

  TaskRepositoryImpl(Ref ref)
      : _tasksRemoteDataSource = ref.read(taskRemoteSourceProvider),
        _localDataSource = ref.read(tasksLocalDataSourceProvider),
        _networkInfo = ref.read(networkInfoProvider);

  @override
  Future<Either<Failure, List<Task>>> getTasksInRange(
    DateTime start,
    DateTime end, {
    Filter filter = Filter.active,
  }) async {
    ServiceRunner<Failure, List<Task>> sR = ServiceRunner(_networkInfo);

    // Step 1: Try fetching data from local store
    final localTasks =
        await _localDataSource.getTasksInRange(start, end, filter);

    // Step 2: If offline, return local tasks
    if (!await _networkInfo.isConnected) {
      return Right(localTasks);
    }

    // Step 3: If online, attempt to fetch data from remote
    return sR
        .tryRemoteAndCatch(
      call: _tasksRemoteDataSource.getTasksInRange(start, end, filter),
      errorTitle: ErrorStrings.GET_TASKS_ERROR,
    )
        .then(
      (result) async {
        return result.fold(
          (l) => Right(localTasks),
          (r) async {
            for (var task in r) {
              await _localDataSource.saveTask(task.copyWith(isSynced: true));
            }
            return Right(r);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, List<Task>>> getTasksForDay(
    DateTime day, {
    Filter filter = Filter.active,
  }) async {
    ServiceRunner<Failure, List<Task>> sR = ServiceRunner(_networkInfo);

    final localRange = await _localDataSource.getCachedRange();

    if (localRange != null && day.isWithinRange(localRange)) {
      final localTasks = await _localDataSource.getTasksInRange(
        day.startOfDay,
        day.endOfDay,
        filter,
      );
      return Right(localTasks);
    }

    final newStart = DateTime(day.year, day.month, 1);
    final newEnd = DateTime(day.year, day.month + 1, 0);

    return sR
        .tryRemoteAndCatch(
      call: _tasksRemoteDataSource.getTasksInRange(newStart, newEnd, filter),
      errorTitle: ErrorStrings.GET_TASKS_ERROR,
    )
        .then(
      (result) async {
        return await result.fold(
          (l) => Left(l),
          (r) async {
            // Cache the fetched tasks locally
            for (var task in r) {
              await _localDataSource.saveTask(task.copyWith(isSynced: true));
            }

            // Return only tasks that fall on the specific `day`
            final tasksForDay =
                r.where((task) => isSameDay(task.date, day)).toList();

            return Right(tasksForDay);
          },
        );
      },
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    final localTask = task.copyWith(isSynced: false);
    await _localDataSource.saveTask(localTask);

    if (!await _networkInfo.isConnected) {
      return Right(localTask);
    }

    ServiceRunner<Failure, Task> sR = ServiceRunner(_networkInfo);

    return sR
        .tryRemoteAndCatch(
      call: _tasksRemoteDataSource.createTask(task.toJson()),
      errorTitle: ErrorStrings.CREATE_TASK_ERROR,
    )
        .then(
      (result) {
        return result.fold(
          (l) => Left(l),
          (r) async {
            await _localDataSource.markTaskAsSynced(r.id);
            return Right(r);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, String>> hardDeleteTask(String id) {
    ServiceRunner<Failure, String> sR = ServiceRunner(_networkInfo);

    return sR.tryRemoteAndCatch(
      call: _tasksRemoteDataSource.hardDeleteTask(id),
      errorTitle: ErrorStrings.HARD_DELETE_TASK_ERROR,
    );
  }

  @override
  Future<Either<Failure, Task>> restoreTask(String id) {
    ServiceRunner<Failure, Task> sR = ServiceRunner(_networkInfo);

    return sR.tryRemoteAndCatch(
      call: _tasksRemoteDataSource.restoreTask(id),
      errorTitle: ErrorStrings.RESTORE_TASK_ERROR,
    );
  }

  @override
  Future<Either<Failure, String>> softDeleteTask(String id) {
    ServiceRunner<Failure, String> sR = ServiceRunner(_networkInfo);

    return sR.tryRemoteAndCatch(
      call: _tasksRemoteDataSource.hardDeleteTask(id),
      errorTitle: ErrorStrings.SOFT_DELETE_TASK_ERROR,
    );
  }

  @override
  Future<Either<Failure, Task>> toggleTaskCompletion(String id) {
    ServiceRunner<Failure, Task> sR = ServiceRunner(_networkInfo);

    return sR.tryRemoteAndCatch(
      call: _tasksRemoteDataSource.toggleTaskCompletion(id),
      errorTitle: ErrorStrings.TOGGLE_TASK_ERROR,
    );
  }

  @override
  Future<Either<Failure, String>> updateTask(
    String id,
    Map<String, dynamic> payload,
  ) {
    ServiceRunner<Failure, String> sR = ServiceRunner(_networkInfo);

    return sR.tryRemoteAndCatch(
      call: _tasksRemoteDataSource.updateTask(id, payload),
      errorTitle: ErrorStrings.TOGGLE_TASK_ERROR,
    );
  }
}

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(ref),
);
