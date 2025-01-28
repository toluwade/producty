import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTimePicker extends StatefulWidget {
  final String? initialTime;
  final Function(String) onTimeSelected;
  final bool isDarkMode;

  const CustomTimePicker({
    Key? key,
    this.initialTime,
    required this.onTimeSelected,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _scrollController;
  late int _selectedIndex;
  final List<String> _times = [
    '11:10 AM',
    '11:15 AM',
    '11:20 AM',
    '11:25 AM',
    '11:30 AM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex =
        widget.initialTime != null ? _times.indexOf(widget.initialTime!) : 0;
    _scrollController =
        FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      child: ListWheelScrollView(
        controller: _scrollController,
        itemExtent: 50.h,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 1.5,
        perspective: 0.005,
        onSelectedItemChanged: (index) {
          HapticFeedback.mediumImpact();
          setState(() {
            _selectedIndex = index;
          });
          widget.onTimeSelected(_times[index]);
          HapticFeedback.heavyImpact();
        },
        children: List.generate(_times.length, (index) {
          final bool isSelected = index == _selectedIndex;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Center(
              child: Text(
                _times[index],
                style: TextStyle(
                    color: isSelected
                        ? (widget.isDarkMode ? Colors.white : Colors.black)
                        : (widget.isDarkMode ? Colors.white60 : Colors.black54),
                    fontSize: isSelected ? 20.sp : 16.sp,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    letterSpacing: isSelected ? 0.5 : 0.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}
