import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color withValues([double opacity = 1.0]) {
    return withOpacity(opacity);
  }
}

class AppColors {
  // Light Theme Colors
  static const primary = Color(0xFF007AFF);
  static const surface = Color(0xFFFFFFFF);
  static const background = Color(0xFFF1F1F1);
  static const error = Color(0xFFDC3545);
  static const white = Color(0xFFFFFFFF);
  static const text = Color(0xFF000000);
  static const grey = Color(0xFF8E8E93);
  static const modalBackground = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFF666666);
  static const textSecondary = Color(0xFF666666);
  static const divider = Color(0xFFE0E0E0);
  static const success = Color(0xFF34C759);

  // Dark Theme Colors
  static const darkPrimary = Color(0xFF0A84FF);
  static const darkSurface = Color(0xFF28282A);
  static const darkBackground = Color(0xFF1C1C1E);
  static const darkError = Color(0xFFFF453A);
  static const darkText = Color(0xFFFFFFFF);
  static const darkGrey = Color(0xFF8E8E93);
  static const darkModalBackground = Color(0xFF28282A);
  static const darkSecondaryText = Color(0xFF8E8E93);
  static const darkSuccess = Color(0xFF34C759);
}
