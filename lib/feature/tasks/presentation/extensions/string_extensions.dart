extension TimeStringToDateTime on String {
  /// Converts a 12-hour format time string like '10:45 PM' + a date into a DateTime string
  /// Example:
  ///   '10:45 PM'.toDateTimeString(DateTime(2025, 5, 13))
  ///   => '2025-05-13 22:45:00.000'
  DateTime toDateTimeString(DateTime date) {
    final timeRegex =
        RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$', caseSensitive: false);
    final match = timeRegex.firstMatch(trim());

    if (match == null) {
      throw const FormatException(
          "Invalid time format: expected something like '10:45 PM'");
    }

    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    final meridiem = match.group(3)!.toUpperCase();

    if (meridiem == 'PM' && hour != 12) hour += 12;
    if (meridiem == 'AM' && hour == 12) hour = 0;

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }
}

extension DurationStringToMinutes on String {
  /// Converts strings like "30m", "1.5h", "2h" into total minutes (int).
  /// Only supports "m" for minutes and "h" for hours (can be decimal).
  int toMinutes() {
    final input = trim().toLowerCase();

    final minuteRegex = RegExp(r'^(\d+)\s*m$');
    final hourRegex = RegExp(r'^(\d*\.?\d+)\s*h$');

    if (minuteRegex.hasMatch(input)) {
      final match = minuteRegex.firstMatch(input)!;
      return int.parse(match.group(1)!);
    } else if (hourRegex.hasMatch(input)) {
      final match = hourRegex.firstMatch(input)!;
      final hours = double.parse(match.group(1)!);
      return (hours * 60).round();
    } else {
      throw const FormatException(
          "Invalid format: use 'Xm' or 'Yh' (e.g. '30m', '1.5h')");
    }
  }
}

extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}

extension DateTimeHeaderExtension on DateTime {
  String getDateHeader() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    if (isSameDayAs(now)) {
      return 'Today';
    } else if (isSameDayAs(yesterday)) {
      return 'Yesterday';
    } else if (isSameDayAs(tomorrow)) {
      return 'Tomorrow';
    } else {
      return '${getDayName()}, ${getMonthName()} $day';
    }
  }

  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String getDayName() {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  String getMonthName() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
