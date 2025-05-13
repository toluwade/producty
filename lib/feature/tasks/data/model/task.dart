import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/hive_constants.dart';

part 'task.g.dart'; // For json_serializable

// Your original Frequency enum (unchanged)
@HiveType(typeId: HiveConstants.frequencyHiveId)
enum Frequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  custom,
}

// Your original Reminder enum (unchanged)
@HiveType(typeId: HiveConstants.reminderHiveId)
enum Reminder {
  @HiveField(0)
  none,
  @HiveField(1)
  fiveMinutes,
  @HiveField(2)
  tenMinutes,
  @HiveField(3)
  fifteenMinutes,
}

// Your Filter enum (unchanged)
enum Filter {
  deleted,
  active,
  all,
}

// Modified Task class using json_serializable
@HiveType(typeId: HiveConstants.taskHiveId)
@JsonSerializable()
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final int duration;

  @HiveField(4)
  final String? category;

  @HiveField(5)
  final Frequency frequency;

  @HiveField(6)
  final Reminder reminder;

  @HiveField(7)
  final String? otherDetails;

  @HiveField(8)
  final bool isCompleted;

  @HiveField(9)
  final bool isDeleted;

  @HiveField(10)
  final String userId;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime? updatedAt;

  @HiveField(13)
  final DateTime? deletedAt;

  @HiveField(14)
  final bool isSynced;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    this.category,
    required this.frequency,
    required this.reminder,
    this.otherDetails,
    this.isCompleted = false,
    this.isDeleted = false,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSynced = false,
  });

  // JSON Serialization
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  // Optional: Implement copyWith manually
  Task copyWith({
    String? id,
    String? title,
    DateTime? date,
    int? duration,
    String? category,
    Frequency? frequency,
    Reminder? reminder,
    String? otherDetails,
    bool? isCompleted,
    bool? isDeleted,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isSynced,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      reminder: reminder ?? this.reminder,
      otherDetails: otherDetails ?? this.otherDetails,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
