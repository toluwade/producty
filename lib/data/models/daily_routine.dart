import 'package:flutter/material.dart';

class DailyRoutineEntry {
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final bool isCompleted;

  const DailyRoutineEntry({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    this.isCompleted = false,
  });

  // Default entries
  static const List<DailyRoutineEntry> defaultEntries = [
    DailyRoutineEntry(
      time: '8:00 AM', 
      title: 'Rise and Shine', 
      description: 'Start your day with energy and purpose',
      icon: Icons.wb_sunny_outlined,
    ),
    DailyRoutineEntry(
      time: '10:00 PM', 
      title: 'Sleep Time', 
      description: 'Wind down and prepare for rest',
      icon: Icons.nightlight_round,
    ),
  ];
}
