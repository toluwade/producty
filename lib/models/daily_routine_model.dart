import 'package:uuid/uuid.dart' as uuid;

class DailyRoutineTask {
  final String id;
  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isCompleted;

  DailyRoutineTask({
    String? id,
    required this.title,
    this.description = '',
    this.startTime,
    this.endTime,
    this.isCompleted = false,
  }) : id = id ?? const uuid.Uuid().v4();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'startTime': startTime?.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  // Create from JSON
  factory DailyRoutineTask.fromJson(Map<String, dynamic> json) => DailyRoutineTask(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    isCompleted: json['isCompleted'] ?? false,
  );
}

class DailyRoutine {
  final DateTime date;
  final List<DailyRoutineTask> tasks;

  DailyRoutine({
    required this.date,
    List<DailyRoutineTask>? tasks,
  }) : tasks = tasks ?? [];

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'tasks': tasks.map((task) => task.toJson()).toList(),
  };

  // Create from JSON
  factory DailyRoutine.fromJson(Map<String, dynamic> json) => DailyRoutine(
    date: DateTime.parse(json['date']),
    tasks: (json['tasks'] as List)
        .map((taskJson) => DailyRoutineTask.fromJson(taskJson))
        .toList(),
  );
}
