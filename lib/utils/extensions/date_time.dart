import 'package:flutter/material.dart';

extension DateTimeRangeCheck on DateTime {
  /// Checks if this DateTime is within (or equal to) a DateTimeRange,
  /// optionally allowing a buffer on both ends.
  bool isWithinRange(DateTimeRange range, {int bufferDays = 15}) {
    final bufferedStart = range.start.subtract(Duration(days: bufferDays));
    final bufferedEnd = range.end.add(Duration(days: bufferDays));
    return isAfter(bufferedStart) && isBefore(bufferedEnd);
  }

  /// Returns the start of the day (00:00:00) for this DateTime.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (exclusive 00:00:00 of next day).
  DateTime get endOfDay => startOfDay.add(const Duration(days: 1));
}

extension ReadableTime on DateTime {
  /// Returns a user-friendly time string like '3:45 PM'
  String toReadableTime() {
    final hour =
        this.hour > 12 ? this.hour - 12 : (this.hour == 0 ? 12 : this.hour);
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
