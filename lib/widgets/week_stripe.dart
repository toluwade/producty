import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeekStripe extends StatelessWidget {
  final PageController pageController;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final bool isDarkMode;
  final bool isRefreshing;
  final List<DateTime> dates;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final bool isStatic;

  const WeekStripe({
    Key? key,
    required this.pageController,
    required this.selectedDate,
    required this.onDateSelected,
    required this.isDarkMode,
    required this.isRefreshing,
    required this.dates,
    required this.currentPageIndex,
    required this.onPageChanged,
    this.isStatic = false,
  }) : super(key: key);

  DateTime _getMondayOfWeek(DateTime date) {
    final difference = date.weekday - 1;
    return date.subtract(Duration(days: difference));
  }

  List<DateTime> _generateWeekDates(DateTime date) {
    final monday = _getMondayOfWeek(date);
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  DateTime _getDateFromPageIndex(int pageIndex) {
    final referenceDate = DateTime(2024, 1, 1);
    return referenceDate.add(Duration(days: pageIndex - 3650));
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (isStatic) {
      return Container(
        height: 80.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: dates.map((date) {
            final isSelected = date.day == selectedDate.day &&
                date.month == selectedDate.month &&
                date.year == selectedDate.year;

            return _buildDateItem(context, date, isSelected);
          }).toList(),
        ),
      );
    }

    return SizedBox(
      height: 80.h,
      child: PageView.builder(
        controller: pageController,
        allowImplicitScrolling: true,
        physics: const AlwaysScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        itemBuilder: (context, pageIndex) {
          final currentDate = _getDateFromPageIndex(pageIndex);
          final weekDates = _generateWeekDates(currentDate);

          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekDates.map((date) {
                final isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;

                final isToday = date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onDateSelected(date),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFACF75F)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(date.weekday),
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            width: 35.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: isDarkMode
                                          ? Colors
                                              .white // White outline in dark mode
                                          : Theme.of(context)
                                              .primaryColor, // Keep primary color in light mode
                                      width: 1.5)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : isToday
                                          ? isDarkMode
                                              ? Colors
                                                  .white // White text for today in dark mode
                                              : Theme.of(context)
                                                  .primaryColor // Keep primary color in light mode
                                          : isDarkMode
                                              ? Colors
                                                  .white // White text for other dates in dark mode
                                              : const Color(
                                                  0xFF3D3D3D), // Softer text in light mode
                                  fontSize: 16.sp,
                                  fontWeight: isSelected || isToday
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateItem(BuildContext context, DateTime date, bool isSelected) {
    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    return Expanded(
      child: GestureDetector(
        onTap: () => onDateSelected(date),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFACF75F) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getDayName(date.weekday),
                style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[600],
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: 35.w,
                height: 35.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  border: isToday && !isSelected
                      ? Border.all(
                          color: isDarkMode
                              ? Colors.white // White outline in dark mode
                              : Theme.of(context)
                                  .primaryColor, // Keep primary color in light mode
                          width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isToday
                              ? isDarkMode
                                  ? Colors
                                      .white // White text for today in dark mode
                                  : Theme.of(context)
                                      .primaryColor // Keep primary color in light mode
                              : isDarkMode
                                  ? Colors
                                      .white // White text for other dates in dark mode
                                  : const Color(
                                      0xFF3D3D3D), // Softer text in light mode
                      fontSize: 16.sp,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
