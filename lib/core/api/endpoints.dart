import 'package:producty/feature/tasks/data/model/task.dart';

class Endpoints {
  static const base = 'http://localhost:3000';

  ////////////////////////////////////
  // Authentication Endpoints
  static const requestOtp = '$base/auth/request-otp';
  static const verifyOtp = '$base/auth/verify-otp';
  static const googleSignIn = '$base/auth/google-signin';
  static const getRefreshToken = '$base/auth/refresh-token';

  ////////////////////////////////////
  // Task Endpoints
  static const tasks = '$base/tasks';

  static String getTasks(Filter filter) => '$tasks?filter=$filter';

  static String getTasksInRange(
    DateTime start,
    DateTime end, {
    Filter? filter,
  }) {
    final startStr = start.toIso8601String();
    final endStr = end.toIso8601String();

    final base = '$tasks?start=$startStr&end=$endStr';
    if (filter != null && filter != Filter.active) {
      return '$base&filter=${filter.name}';
    }
    return base;
  }

  static String createTask = tasks;

  static String updateTask(String id) => '$tasks/$id';

  static String toggleCompletion(String id) => '$tasks/$id/toggle-completion';

  static String softDeleteTask(String id) => '$tasks/$id/soft-delete';

  static String restoreTask(String id) => '$tasks/$id/restore';

  static String hardDeleteTask(String id) => '$tasks/$id';
}
