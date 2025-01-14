import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DayWidget extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isDarkMode;

  const DayWidget({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isDarkMode,
  });

  // Helper method to check if a date is today
  bool _isDateToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Helper method to get day of week abbreviation
  String _getDayAbbreviation(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }

  void _onDateTap() {
    // Trigger Haptic Feedback
    HapticFeedback.lightImpact();
    
    // Call the date selection callback
    // widget.onDateSelected(widget.date); // Removed this line
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _isDateToday(date);

    return GestureDetector(
      onTap: _onDateTap,
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Day of the week (Text)
            Text(
              _getDayAbbreviation(date.weekday),
              style: const TextStyle(
                color: Color(0xFF93939A),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Day of the month (Container)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday 
                    ? const Color(0xFF3D3D3D) 
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                      ? const Color(0xFF3D3D3D)
                      : Colors.transparent,
                  width: isSelected ? 2 : 0,
                ),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isToday 
                        ? const Color(0xFFFFFFFF) 
                        : const Color(0xFF3D3D3D),
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
