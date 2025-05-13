import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/network/network.dart';
import '../model/task.dart';

abstract class TasksRemoteDataSource {
  Future<List<Task>> getTasksInRange(
    DateTime start,
    DateTime end,
    Filter filter,
  );
  Future<Task> createTask(Map<String, dynamic> payload);
  Future<String> updateTask(String id, Map<String, dynamic> payload);
  Future<Task> toggleTaskCompletion(String id);
  Future<void> softDeleteTask(String id);
  Future<Task> restoreTask(String id);
  Future<String> hardDeleteTask(String id);
}

class TasksRemoteDataSourceImpl extends TasksRemoteDataSource {
  final NetworkRequest networkRequest;
  final NetworkRetry networkRetry;

  TasksRemoteDataSourceImpl({
    required this.networkRequest,
    required this.networkRetry,
  });

  @override
  Future<List<Task>> getTasksInRange(
    DateTime start,
    DateTime end,
    Filter filter,
  ) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.get(
        Endpoints.getTasksInRange(start, end, filter: filter),
      ),
    );

    final data = response.data['data'];

    if (response.isSuccess) {
      return (data as List).map((e) => Task.fromJson(e)).toList();
    } else {
      final errorMessage = data['message'] ?? 'Something went wrong';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<Task> createTask(Map<String, dynamic> payload) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.post(
        Endpoints.createTask,
        body: payload,
      ),
    );

    final data = response.data['data'];

    if (response.isSuccess) {
      return Task.fromJson(data);
    } else {
      final errorMessage = data['message'] ?? 'Unable to create task';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<String> updateTask(String id, Map<String, dynamic> payload) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.patch(
        Endpoints.updateTask(id),
        body: payload,
      ),
    );

    if (!response.isSuccess) {
      final errorMessage = response.data['message'] ?? 'Unable to update task';
      throw Exception(errorMessage);
    }

    return response.data['message'];
  }

  @override
  Future<Task> toggleTaskCompletion(String id) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.patch(
        Endpoints.toggleCompletion(id),
      ),
    );

    final data = response.data['data'];

    if (response.isSuccess) {
      return Task.fromJson(data);
    } else {
      final errorMessage = data['message'] ?? 'Unable to toggle completion';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> softDeleteTask(String id) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.patch(
        Endpoints.softDeleteTask(id),
      ),
    );

    if (!response.isSuccess) {
      final errorMessage =
          response.data['message'] ?? 'Unable to soft delete task';
      throw Exception(errorMessage);
    }

    return response.data['message'];
  }

  @override
  Future<Task> restoreTask(String id) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.patch(
        Endpoints.restoreTask(id),
      ),
    );

    final data = response.data['data'];

    if (response.isSuccess) {
      return Task.fromJson(data);
    } else {
      final errorMessage = data['message'] ?? 'Unable to restore task';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<String> hardDeleteTask(String id) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.delete(
        Endpoints.hardDeleteTask(id),
      ),
    );

    if (!response.isSuccess) {
      final errorMessage = response.data['message'] ?? 'Unable to delete task';
      throw Exception(errorMessage);
    }

    return response.data['message'];
  }
}

final taskRemoteSourceProvider = Provider<TasksRemoteDataSource>(
  (ref) => TasksRemoteDataSourceImpl(
    networkRequest: ref.read(networkRequestProvider),
    networkRetry: ref.read(networkRetryProvider),
  ),
);
