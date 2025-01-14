import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_routine_model.dart';

class DailyRoutineService {
  static const String _routinesKey = 'daily_routines';

  // Save a daily routine
  Future<void> saveDailyRoutine(DailyRoutine routine) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing routines
    final routinesJson = prefs.getStringList(_routinesKey) ?? <String>[];
    
    // Remove existing routine for the same date if exists
    routinesJson.removeWhere((json) {
      final existingRoutine = DailyRoutine.fromJson(jsonDecode(json));
      return existingRoutine.date.isAtSameMomentAs(routine.date);
    });
    
    // Add new routine
    routinesJson.add(jsonEncode(routine.toJson()));
    
    // Save updated list
    await prefs.setStringList(_routinesKey, routinesJson);
  }

  // Get a daily routine for a specific date
  Future<DailyRoutine> getDailyRoutine(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing routines
    final routinesJson = prefs.getStringList(_routinesKey) ?? <String>[];
    
    // Find routine for the specific date
    for (final json in routinesJson) {
      final routine = DailyRoutine.fromJson(jsonDecode(json));
      if (_isSameDay(routine.date, date)) {
        return routine;
      }
    }
    
    // If no routine exists, return an empty routine for the date
    return DailyRoutine(date: date);
  }

  // Save a task for a specific date
  Future<void> saveTaskForDate(DateTime date, DailyRoutineTask task) async {
    final routine = await getDailyRoutine(date);
    routine.tasks.add(task);
    await saveDailyRoutine(routine);
  }

  // Add a task to a daily routine
  Future<void> addTaskToRoutine(DateTime date, DailyRoutineTask task) async {
    final routine = await getDailyRoutine(date);
    routine.tasks.add(task);
    await saveDailyRoutine(routine);
  }

  // Update a task in a daily routine
  Future<void> updateTask(DateTime date, DailyRoutineTask updatedTask) async {
    final routine = await getDailyRoutine(date);
    final index = routine.tasks.indexWhere((task) => task.id == updatedTask.id);
    
    if (index != -1) {
      routine.tasks[index] = updatedTask;
      await saveDailyRoutine(routine);
    }
  }

  // Delete a task from a daily routine
  Future<void> deleteTask(DateTime date, String taskId) async {
    final routine = await getDailyRoutine(date);
    routine.tasks.removeWhere((task) => task.id == taskId);
    await saveDailyRoutine(routine);
  }

  // Helper method to check if two dates are on the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
