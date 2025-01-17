import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialSelectedDate;
  final Function(DateTime) onDateSelected;
  final String? currentMonthYear;
  final Function(int, int)? onMonthYearChanged;

  const CalendarBottomSheet({
    super.key,
    required this.initialSelectedDate,
    required this.onDateSelected,
    this.currentMonthYear,
    this.onMonthYearChanged,
  });

  @override
  CalendarBottomSheetState createState() => CalendarBottomSheetState();
}

class CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final bool _shouldScrollToSelectedDay = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialSelectedDate;
    _focusedDay = widget.initialSelectedDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(35.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modal handle
          Container(
            width: 50.w,
            height: 5.h,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          // Calendar
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            calendarStyle: CalendarStyle(
              // Today's date style
              todayDecoration: BoxDecoration(
                color:
                    isDarkMode ? const Color(0xFFACF75F) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFFACF75F)
                      : Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              todayTextStyle: TextStyle(
                color: isDarkMode ? const Color(0xFF3D3D3D) : Colors.black,
                fontWeight: FontWeight.bold,
              ),

              // Selected date style
              selectedDecoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFFACF75F)
                    : Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: isDarkMode ? const Color(0xFF3D3D3D) : Colors.white,
                fontWeight: FontWeight.bold,
              ),

              // Default text styles
              defaultTextStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              weekendTextStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
              outsideTextStyle: TextStyle(
                color: isDarkMode ? Colors.white24 : Colors.black26,
              ),

              // Disabled dates
              disabledTextStyle: TextStyle(
                color: isDarkMode ? Colors.white24 : Colors.black26,
              ),

              // Weekend dates
              weekendDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),

              // Cell margins
              cellMargin: EdgeInsets.all(4.w),
              cellPadding: EdgeInsets.zero,
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              weekendStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Go to Day CTA
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: ElevatedButton(
              onPressed: () {
                widget.onDateSelected(_selectedDay);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: const Color(0xFF3D3D3D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Go to ${DateFormat('MMMM d').format(_selectedDay)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Iconsax.arrow_right_3,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h), // Add bottom padding
        ],
      ),
    );
  }
}
