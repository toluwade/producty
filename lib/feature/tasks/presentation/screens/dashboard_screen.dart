import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:producty/config/router/app_router.gr.dart';

import '../../../../config/router/app_router.dart';
import '../../../../widgets/custom_toast.dart';
import '../../../../widgets/week_stripe.dart';
import '../widgets/calendar_bottom_sheet.dart';
import '../widgets/coming_soon_bottom_sheet.dart';
import '../widgets/daily_routine_widget.dart';
import '../widgets/dashboard_app_bar.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _calendarAnimationController;
  late final AnimationController _toggleAnimationController;
  int _currentPageIndex = 3650;
  bool _isRefreshing = false;
  DateTime? _lastToastTime;
  bool _isAnalyticsMode = false;

  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers first
    _calendarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _toggleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {});
      });

    // Initialize other controllers and state
    final now = DateTime.now();
    final daysDifference = now.difference(DateTime(2024, 1, 1)).inDays;
    final initialPageIndex = 3650 + (daysDifference ~/ 7);

    final weekStart = _getStartOfWeek(now);
    dates = List.generate(7, (index) => weekStart.add(Duration(days: index)));
    selectedDate = now;
    _currentPageIndex = initialPageIndex;

    _pageController = PageController(
      initialPage: initialPageIndex,
      viewportFraction: 1.0,
    );

    // Load initial routines
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<DailyRoutineProvider>(context, listen: false)
    //       .loadRoutinesForDate(selectedDate);
    // });
  }

  bool _isViewingToday() {
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  void _showToast(String message) {
    final now = DateTime.now();
    if (_lastToastTime != null &&
        now.difference(_lastToastTime!) < const Duration(milliseconds: 300)) {
      return;
    }
    _lastToastTime = now;

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    CustomToast.show(context, message);
  }

  Future<void> _refreshDashboard() async {
    if (_isRefreshing) return;

    try {
      _isRefreshing = true;

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      final now = DateTime.now();
      final daysDifference = now.difference(DateTime(2024, 1, 1)).inDays;
      final newPageIndex = 3650 + (daysDifference ~/ 7);

      final weekStart = _getStartOfWeek(now);
      setState(() {
        selectedDate = now;
        _currentPageIndex = newPageIndex;
        dates =
            List.generate(7, (index) => weekStart.add(Duration(days: index)));
      });

      await _pageController.animateToPage(
        newPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      if (mounted) {
        // Provider.of<TodoProvider>(context, listen: false).refreshTodos();
        _showToast("You're viewing today's date.");
      }
    } catch (e) {
      if (mounted) {
        _showToast("Failed to refresh. Please try again.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _getDateFromPageIndex(int pageIndex) {
    final referenceDate = DateTime(2024, 1, 1);
    return referenceDate.add(Duration(days: (pageIndex - 3650) * 7));
  }

  (int, int) _calculateMonthAndYear(int pageIndex) {
    return (selectedDate.year, selectedDate.month);
  }

  String _getMonthName(int month) {
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

  List<DateTime> _generateDatesForMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    List<DateTime> dates = [];
    for (var date = firstDay;
        date.isBefore(lastDay.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      dates.add(date);
    }
    return dates;
  }

  void _showCalendarBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarBottomSheet(
        initialSelectedDate: selectedDate,
        currentMonthYear:
            '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
        onDateSelected: (DateTime selectedDay) async {
          final daysDifference =
              selectedDay.difference(DateTime(2024, 1, 1)).inDays;
          final newPageIndex = 3650 + (daysDifference ~/ 7);

          await _pageController.animateToPage(
            newPageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );

          if (mounted) {
            final weekStart = _getStartOfWeek(selectedDay);
            setState(() {
              selectedDate = selectedDay;
              _currentPageIndex = newPageIndex;
              dates = List.generate(
                  7, (index) => weekStart.add(Duration(days: index)));
            });

            if (!_isViewingToday()) {
              _showToast("Pull down to refresh and view today's date.");
            }
          }
        },
        onMonthYearChanged: (int year, int month) {
          setState(() {
            // Optional: Add any necessary state updates
          });
        },
      ),
    ).whenComplete(() {
      _calendarAnimationController.reverse();
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      final weekStart = _getStartOfWeek(date);
      dates = List.generate(7, (index) => weekStart.add(Duration(days: index)));
    });
    // Load routines for the selected date
    // Provider.of<DailyRoutineProvider>(context, listen: false)
    //     .loadRoutinesForDate(date);
  }

  void _showAnalyticsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComingSoonBottomSheet(
        onClose: () {
          Navigator.pop(context);
          setState(() => _isAnalyticsMode = false);
          _toggleAnimationController.reverse();
        },
      ),
    ).whenComplete(() {
      setState(() => _isAnalyticsMode = false);
      _toggleAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final (year, month) = _calculateMonthAndYear(_currentPageIndex);
    final currentMonthYear = '${_getMonthName(month)} $year';

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF1F1F1),
      appBar: DashboardAppBar(
        isDarkMode: isDarkMode,
        currentMonthYear: currentMonthYear,
        calendarAnimationController: _calendarAnimationController,
        toggleAnimationController: _toggleAnimationController,
        onCalendarTap: () {
          _showCalendarBottomSheet();
          _calendarAnimationController.forward(from: 0.0);
        },
        onTimelineSelected: () => setState(() => _isAnalyticsMode = false),
        onAnalyticsSelected: () {
          setState(() => _isAnalyticsMode = true);
          _showAnalyticsBottomSheet();
        },
        onProfileTap: () => Nav.push(context, const ProfileRoute()),
        isAnalyticsMode: _isAnalyticsMode,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RefreshIndicator(
            onRefresh: _refreshDashboard,
            color: Theme.of(context).primaryColor,
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5.h),
                WeekStripe(
                  pageController: _pageController,
                  selectedDate: selectedDate,
                  onDateSelected: _onDateSelected,
                  isDarkMode: isDarkMode,
                  isRefreshing: _isRefreshing,
                  dates: dates,
                  currentPageIndex: _currentPageIndex,
                  onPageChanged: (int pageIndex) {
                    if (_isRefreshing) return;

                    HapticFeedback.lightImpact();
                    final currentDate = _getDateFromPageIndex(pageIndex);

                    setState(() {
                      _currentPageIndex = pageIndex;
                      selectedDate = currentDate;
                      final weekStart = _getStartOfWeek(currentDate);
                      dates = List.generate(
                        7,
                        (index) => weekStart.add(
                          Duration(days: index),
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: 5.h),
                Expanded(
                  child: DailyRoutineWidget(
                    selectedDate: selectedDate,
                    onDateChanged: (DateTime newDate) {
                      final daysDifference =
                          newDate.difference(DateTime(2024, 1, 1)).inDays;
                      final newPageIndex = 3650 + (daysDifference ~/ 7);

                      _pageController.animateToPage(
                        newPageIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );

                      setState(() {
                        selectedDate = newDate;
                        _currentPageIndex = newPageIndex;
                        final weekStart = _getStartOfWeek(newDate);
                        dates = List.generate(
                            7, (index) => weekStart.add(Duration(days: index)));
                      });

                      // Load routines for the new date
                      // Provider.of<DailyRoutineProvider>(context,
                      //         listen: false)
                      //     .loadRoutinesForDate(newDate);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: null,
      bottomNavigationBar: null,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _calendarAnimationController.dispose();
    _toggleAnimationController.dispose();
    super.dispose();
  }
}
