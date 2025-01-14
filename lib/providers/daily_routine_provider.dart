import 'package:flutter/foundation.dart';
import '../models/daily_routine_entry.dart';

class DailyRoutineProvider extends ChangeNotifier {
  final List<DailyRoutineEntry> _entries = DailyRoutineEntry.defaultEntries;

  List<DailyRoutineEntry> get entries => List.unmodifiable(_entries);

  void addRoutineEntry(DailyRoutineEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void removeRoutineEntry(DailyRoutineEntry entry) {
    _entries.remove(entry);
    notifyListeners();
  }

  void updateRoutineEntry(DailyRoutineEntry oldEntry, DailyRoutineEntry newEntry) {
    final index = _entries.indexOf(oldEntry);
    if (index != -1) {
      _entries[index] = newEntry;
      notifyListeners();
    }
  }

  void toggleEntryCompletion(DailyRoutineEntry entry) {
    final index = _entries.indexOf(entry);
    if (index != -1) {
      _entries[index].toggleCompletion();
      notifyListeners();
    }
  }

  void clearAllEntries() {
    _entries.clear();
    notifyListeners();
  }
}
