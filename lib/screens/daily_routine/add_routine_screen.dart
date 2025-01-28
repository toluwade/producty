import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../../models/daily_routine_entry.dart';
import '../../widgets/custom_time_picker.dart';

class AddRoutineScreen extends StatefulWidget {
  final Function(DailyRoutineEntry) onRoutineAdded;
  final DateTime selectedDate;

  const AddRoutineScreen({
    Key? key,
    required this.onRoutineAdded,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  String _selectedTime = '9:00 AM';
  String _selectedDuration = '1m';
  String _displayTimeRange = '';
  String _selectedCategory = 'Work';
  String _selectedFrequency = 'Once';
  String _selectedReminder = 'At start of task';
  int _currentStep = 0;

  static const String _createTaskText = 'Create a New Task';

  final Map<String, Color> categoryColors = {
    'Work': Colors.blue,
    'Personal': Colors.purple,
    'Health': Colors.green,
    'Study': Colors.orange,
  };

  final List<String> durations = ['1m', '5m', '15m', '30m', '1h', 'Custom'];
  final List<String> frequencies = ['Once', 'Daily', 'Weekly', 'Monthly'];
  final List<String> reminders = [
    'At start of task',
    'At the end',
    '5min before start',
    'Other'
  ];

  List<Widget> get _steps {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return [
      // Step 1: Basic Info
      Column(
        children: [
          _buildFormField(
            label: 'New Task Title',
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFFACF75F).withOpacity(0.2)
                        : const Color(0xFFACF75F),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      'T',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? const Color(0xFFACF75F)
                            : const Color(0xFF3D3D3D),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: 'What do you need to do?',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          _buildFormField(
            label: 'When?',
            isTimeField: true,
            child: Container(
              height: 110.h,
              padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy.abs() > 2) {
                    setState(() {
                      final baseTime = _parseTime(_selectedTime);
                      if (baseTime != null) {
                        // Determine direction and amount of time to add/subtract
                        final minutesToAdd = details.delta.dy > 0 ? 15 : -15;
                        final newTime =
                            baseTime.add(Duration(minutes: minutesToAdd));
                        _selectedTime = _formatTime(newTime);
                        _updateTimeRange();
                        HapticFeedback.lightImpact();
                      }
                    });
                  }
                },
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white,
                        Colors.white,
                        Colors.transparent
                      ],
                      stops: [0.0, 0.2, 0.8, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(7, (index) {
                      final isMiddle = index == 3;
                      final time = _generateTimeForIndex(index - 2);
                      final distanceFromMiddle = (index - 3).abs();
                      final opacity = isMiddle
                          ? 1.0
                          : distanceFromMiddle <= 2
                              ? (1.0 - (0.35 * distanceFromMiddle))
                              : 0.25;
                      final verticalOffset = (index - 3) * 22.h;

                      return Positioned(
                        top: 55.h + verticalOffset - (isMiddle ? 16.h : 10.h),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                            setState(() {
                              _selectedTime = time;
                              _updateTimeRange();
                            });
                          },
                          child: Container(
                            height: isMiddle ? 32.h : 20.h,
                            width: isMiddle ? 162.w : 120.w,
                            decoration: BoxDecoration(
                              color: isMiddle
                                  ? const Color(0xFFACF75F)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: Opacity(
                                opacity: opacity,
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: isMiddle
                                        ? const Color(0xFF3D3D3D)
                                        : (isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                    fontSize: isMiddle ? 14.sp : 13.sp,
                                    fontWeight: isMiddle
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    letterSpacing: isMiddle ? 0.5 : 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          _buildFormField(
            label: 'For How Long?',
            isForHowLong: true,
            customAction: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
              },
              child: Text(
                'Custom',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            child: Container(
              height: 42.h,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  for (String duration in [
                    '1',
                    '15',
                    '30',
                    '45m',
                    '1h',
                    '1.5h'
                  ])
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDuration =
                                duration.endsWith('m') || duration.endsWith('h')
                                    ? duration
                                    : '${duration}m';
                            _updateTimeRange();
                          });
                          HapticFeedback.mediumImpact();
                        },
                        child: Container(
                          height: 42.h,
                          decoration: BoxDecoration(
                            color: (_selectedDuration == duration ||
                                    _selectedDuration == '${duration}m')
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              duration,
                              style: TextStyle(
                                color: (_selectedDuration == duration ||
                                        _selectedDuration == '${duration}m')
                                    ? const Color(0xFF3D3D3D)
                                    : (isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                fontSize: 13.sp,
                                fontWeight: (_selectedDuration == duration ||
                                        _selectedDuration == '${duration}m')
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Step 2: Category and Frequency
      Column(
        children: [
          _buildFormField(
            label: 'What category is this?',
            child: _buildCategoryChips(),
          ),
          _buildFormField(
            label: 'How often?',
            icon: Iconsax.repeat_circle,
            child: DropdownButtonFormField<String>(
              value: _selectedFrequency,
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: frequencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedFrequency = newValue);
                }
              },
            ),
          ),
          _buildFormField(
            label: 'Reminder',
            icon: Iconsax.notification,
            child: DropdownButtonFormField<String>(
              value: _selectedReminder,
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: reminders.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedReminder = newValue);
                }
              },
            ),
          ),
        ],
      ),
      // Step 3: Details
      Column(
        children: [
          _buildFormField(
            label: 'Any details?',
            icon: Iconsax.document_text,
            child: TextField(
              controller: _detailsController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
              ),
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                    'Add subtasks, notes, meeting links, or phone numbers',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void _updateTimeRange() {
    final startTime = _parseTime(_selectedTime);
    if (startTime != null) {
      if (_selectedDuration == '1m') {
        _displayTimeRange = _formatTime(startTime);
      } else {
        final duration = _parseDuration(_selectedDuration);
        final endTime = startTime.add(Duration(minutes: duration));
        _displayTimeRange =
            '${_formatTime(startTime)} - ${_formatTime(endTime)}';
      }
    }
  }

  DateTime? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      var hour = int.parse(parts[0]);
      final minuteParts = parts[1].split(' ');
      final minutes = int.parse(minuteParts[0]);
      final isPM = minuteParts[1].toUpperCase() == 'PM';

      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minutes);
    } catch (e) {
      return null;
    }
  }

  int _parseDuration(String durationStr) {
    try {
      if (durationStr.endsWith('h')) {
        // Handle hour format (including decimals)
        final hourValue =
            double.parse(durationStr.substring(0, durationStr.length - 1));
        return (hourValue * 60).round();
      } else if (durationStr.endsWith('m')) {
        // Handle minute format
        return int.parse(durationStr.substring(0, durationStr.length - 1));
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _getTimeRangeDisplay(String startTime) {
    final start = _parseTime(startTime);
    if (start != null) {
      if (_selectedDuration == '1m') {
        return startTime;
      } else {
        final duration = _parseDuration(_selectedDuration);
        final endTime = start.add(Duration(minutes: duration));
        return '${_formatTime(start)} - ${_formatTime(endTime)}';
      }
    }
    return startTime;
  }

  bool get _isLastStep => _currentStep == _steps.length - 1;

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    IconData? icon,
    bool isLast = false,
    bool isTimeField = false,
    bool isForHowLong = false,
    Widget? customAction,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: (isTimeField || isForHowLong) ? 0 : 12.w,
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12.sp,
                ),
              ),
            ),
            if (customAction != null) ...[
              SizedBox(width: 8.w),
              customAction,
            ],
          ],
        ),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color: isTimeField
                ? Colors.transparent
                : (isDarkMode
                    ? Colors.grey[800]!.withOpacity(0.5)
                    : Colors.grey[100]),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: (isTimeField || isForHowLong) ? 0 : 12.w,
              vertical: 2.h),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18.sp,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(child: child),
            ],
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildCategoryChips() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 8.w,
      children: categoryColors.entries.map((entry) {
        final isSelected = _selectedCategory == entry.key;
        return ChoiceChip(
          label: Text(
            entry.key,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black),
              fontSize: 12.sp,
            ),
          ),
          selected: isSelected,
          selectedColor: entry.value,
          backgroundColor: isDarkMode
              ? Colors.grey[800]!.withOpacity(0.5)
              : Colors.grey[200]!.withOpacity(0.5),
          onSelected: (bool selected) {
            if (selected) {
              setState(() => _selectedCategory = entry.key);
            }
          },
        );
      }).toList(),
    );
  }

  String _generateTimeForIndex(int index) {
    final baseTime = _parseTime(_selectedTime);
    if (baseTime == null) return _selectedTime;

    final minutesToAdd =
        (index - 2) * 15; // -30, -15, 0, 15, 30 minutes from selected time
    final newTime = baseTime.add(Duration(minutes: minutesToAdd));
    return _formatTime(newTime);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
        ),
        constraints: BoxConstraints(
          maxWidth: 0.9.sw,
          minHeight: 0.1.sh,
          maxHeight: 0.63.sh,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 32.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[800]
                          : const Color(0xFFACF75F),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.task_square,
                          size: 16.sp,
                          color: isDarkMode
                              ? const Color(0xFFACF75F)
                              : const Color(0xFF3D3D3D),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _createTaskText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey[800]!.withOpacity(0.5)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Iconsax.close_circle,
                        size: 20.sp,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: _steps[_currentStep],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: GestureDetector(
                        onTap: _previousStep,
                        child: Container(
                          height: 48.h,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[800]!.withOpacity(0.5)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        if (_isLastStep) {
                          if (_titleController.text.isNotEmpty) {
                            final newEntry = DailyRoutineEntry(
                              title: _titleController.text,
                              description: _detailsController.text,
                              time: _selectedTime,
                              isCompleted: false,
                            );
                            widget.onRoutineAdded(newEntry);
                          }
                        } else {
                          _nextStep();
                        }
                      },
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFFACF75F)
                              : const Color(0xFF3D3D3D),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Center(
                          child: Text(
                            _isLastStep ? _createTaskText : 'Continue',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
