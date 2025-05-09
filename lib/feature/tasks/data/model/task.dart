import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum Frequency {
  daily,
  weekly,
  monthly,
  custom,
}

enum Reminder {
  none,
  fiveMinutes,
  tenMinutes,
  fifteenMinutes,
}

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    DateTime? time,
    required int duration,
    String? category,
    required Frequency frequency,
    required Reminder reminder,
    String? otherDetails,
    @Default(false) bool isCompleted,
    @Default(false) bool isDeleted,
    required String userId,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
