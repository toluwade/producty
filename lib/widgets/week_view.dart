import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'day_widget.dart';

class WeekView extends StatefulWidget {
  final List<DateTime> dates;
  final DateTime selectedDate;
  final bool isDarkMode;
  final Function(DateTime) onDateSelected;

  const WeekView({
    Key? key,
    required this.dates,
    required this.selectedDate,
    required this.isDarkMode,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(WeekView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Scroll to the selected date when it changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _scrollToSelectedDate() {
    if (_scrollController.hasClients) {
      // Find the index of the selected date
      final selectedIndex = widget.dates.indexWhere((date) => 
        isSameDay(date, widget.selectedDate)
      );

      if (selectedIndex != -1) {
        // Calculate the scroll position
        // Assumes each day widget is approximately 60 pixels wide with 8 pixels padding
        final scrollPosition = (selectedIndex * (60.w + 8.w)) - (context.size!.width / 2) + (30.w);
        
        _scrollController.animateTo(
          scrollPosition, 
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        key: ValueKey(widget.dates.hashCode),
        scrollDirection: Axis.horizontal,
        itemCount: widget.dates.length,
        itemBuilder: (context, index) {
          final date = widget.dates[index];
          final isSelected = isSameDay(date, widget.selectedDate);
          
          return Padding(
            key: ValueKey(date),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () => widget.onDateSelected(date),
              child: DayWidget(
                date: date,
                isSelected: isSelected,
                isDarkMode: widget.isDarkMode,
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to check if two dates are on the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
