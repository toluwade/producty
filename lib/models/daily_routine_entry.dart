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
}
