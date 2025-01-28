class DailyRoutineEntry {
  final String title;
  final String description;
  final String time;
  final bool _isCompleted;

  DailyRoutineEntry({
    required this.title,
    this.description = '',
    this.time = '',
    bool isCompleted = false,
  }) : _isCompleted = isCompleted;

  bool get isCompleted => _isCompleted;

  // Method to toggle completion status
  DailyRoutineEntry toggleCompletion() {
    return DailyRoutineEntry(
      title: title,
      description: description,
      time: time,
      isCompleted: !_isCompleted,
    );
  }

  // Convert to JSON for storage or transmission
  Map<String, dynamic> toJson() => {
        'time': time,
        'title': title,
        'description': description,
        'isCompleted': _isCompleted,
      };

  // Create from JSON
  factory DailyRoutineEntry.fromJson(Map<String, dynamic> json) {
    return DailyRoutineEntry(
      time: json['time'],
      title: json['title'],
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Default entries for initial state
  static List<DailyRoutineEntry> get defaultEntries => [
        DailyRoutineEntry(
          time: '08:00 AM',
          title: 'Morning Workout',
          description: 'Yoga and stretching',
        ),
        DailyRoutineEntry(
          time: '09:30 AM',
          title: 'Breakfast',
          description: 'Healthy breakfast and coffee',
        ),
        DailyRoutineEntry(
          time: '11:00 AM',
          title: 'Work Session',
          description: 'Focus on priority tasks',
        ),
      ];
}
