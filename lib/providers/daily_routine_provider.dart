import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/daily_routine_entry.dart';
import '../services/daily_routine_service.dart';

class DailyRoutineProvider extends ChangeNotifier {
  final Map<DateTime, List<DailyRoutineEntry>> _routinesByDate = {};
  final DailyRoutineService _routineService = DailyRoutineService();

  List<DailyRoutineEntry> getEntriesForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return List.unmodifiable(_routinesByDate[key] ?? []);
  }

  Future<void> loadRoutinesForDate(DateTime date) async {
    final key = DateTime(date.year, date.month, date.day);
    final routine = await _routineService.getDailyRoutine(date);

    // Convert DailyRoutineTask to DailyRoutineEntry
    final entries = routine.tasks
        .map((task) => DailyRoutineEntry(
              title: task.title,
              description: task.description,
              time: task.startTime != null
                  ? DateFormat('h:mm a').format(task.startTime!)
                  : '',
              isCompleted: task.isCompleted,
            ))
        .toList();

    _routinesByDate[key] = entries;
    notifyListeners();
  }

  void addRoutineEntryForDate(DateTime date, DailyRoutineEntry entry) {
    final key = DateTime(date.year, date.month, date.day);
    if (!_routinesByDate.containsKey(key)) {
      _routinesByDate[key] = [];
    }
    _routinesByDate[key]!.add(entry);
    notifyListeners();
  }

  void removeRoutineEntryForDate(DateTime date, DailyRoutineEntry entry) {
    final key = DateTime(date.year, date.month, date.day);
    _routinesByDate[key]?.remove(entry);
    notifyListeners();
  }

  void updateRoutineEntryForDate(
      DateTime date, DailyRoutineEntry oldEntry, DailyRoutineEntry newEntry) {
    final key = DateTime(date.year, date.month, date.day);
    final entries = _routinesByDate[key];
    if (entries != null) {
      final index = entries.indexOf(oldEntry);
      if (index != -1) {
        entries[index] = newEntry;
        notifyListeners();
      }
    }
  }

  void toggleEntryCompletionForDate(DateTime date, DailyRoutineEntry entry) {
    final key = DateTime(date.year, date.month, date.day);
    final entries = _routinesByDate[key];
    if (entries != null) {
      final index = entries.indexOf(entry);
      if (index != -1) {
        entries[index] = entry.toggleCompletion();
        notifyListeners();
      }
    }
  }

  void clearEntriesForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    _routinesByDate.remove(key);
    notifyListeners();
  }
}
