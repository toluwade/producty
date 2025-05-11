import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:producty/core/constants/hive_constants.dart';

const String _settingsBox = HiveConstants.settingsBox;
const String _themeModeKey = HiveConstants.themeModeKey;

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final box = await Hive.openBox(_settingsBox);
    final savedTheme = box.get(_themeModeKey);

    if (savedTheme != null && savedTheme is String) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;

    state = mode;
    final box = await Hive.openBox(_settingsBox);
    await box.put(_themeModeKey, mode.toString());
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
