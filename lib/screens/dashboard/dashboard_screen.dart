import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/todo_provider.dart';
import '../../widgets/todo_list_item.dart';
import '../../widgets/week_view.dart';
import '../../widgets/daily_routine_widget.dart';
import '../../widgets/calendar_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/week_stripe.dart';
import '../../providers/daily_routine_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPageIndex = 3650;
  bool _isRefreshing = false;
  DateTime? _lastToastTime;

  List<DateTime> dates = [];
  DateTime selectedDate = DateTime.now();

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
        Provider.of<TodoProvider>(context, listen: false).refreshTodos();
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

  @override
  void initState() {
    super.initState();

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

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Load initial routines
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyRoutineProvider>(context, listen: false)
          .loadRoutinesForDate(selectedDate);
    });
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
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
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
      _animationController.reverse();
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      final weekStart = _getStartOfWeek(date);
      dates = List.generate(7, (index) => weekStart.add(Duration(days: index)));
    });
    // Load routines for the selected date
    Provider.of<DailyRoutineProvider>(context, listen: false)
        .loadRoutinesForDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final (year, month) = _calculateMonthAndYear(_currentPageIndex);
    final currentMonthYear = '${_getMonthName(month)} $year';

    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomMargin = 10.h;
    const appBarHeight = kToolbarHeight;
    final weekViewHeight = 100.h;

    final dailyRoutineHeight = screenHeight -
        statusBarHeight -
        appBarHeight -
        weekViewHeight -
        bottomMargin;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF1F1F1),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
          systemNavigationBarColor:
              isDarkMode ? Colors.grey[900] : const Color(0xFFF1F1F1),
          systemNavigationBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      _showCalendarBottomSheet();
                      _animationController.forward(from: 0.0);
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 120.w,
                        maxWidth: constraints.maxWidth * 0.5,
                      ),
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF2C2C2C)
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Iconsax.calendar,
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF3D3D3D),
                              size: 24.sp,
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  currentMonthYear,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF3D3D3D),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            RotationTransition(
                              turns: Tween(begin: 0.0, end: 0.5)
                                  .animate(_animationController),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF3D3D3D),
                                size: 20.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF2C2C2C)
                          : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Iconsax.user,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF3D3D3D),
                          size: 24.sp,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/profile'),
                        tooltip: 'Profile',
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RefreshIndicator(
            onRefresh: _refreshDashboard,
            color: Theme.of(context).primaryColor,
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                            7, (index) => weekStart.add(Duration(days: index)));
                      });
                    },
                  ),
                  SizedBox(height: 5.h),
                  SizedBox(
                    height: dailyRoutineHeight,
                    child: DailyRoutineWidget(
                      selectedDate: selectedDate,
                    ),
                  ),
                  SizedBox(height: bottomMargin),
                ],
              ),
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
    _animationController.dispose();
    super.dispose();
  }
}
