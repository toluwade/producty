import 'package:flutter/services.dart';

class Haptics {
  static void softImpact() {
    HapticFeedback.selectionClick();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void strongImpact() {
    HapticFeedback.heavyImpact();
  }

  static void error() {
    HapticFeedback.vibrate();
  }

  static void success() {
    HapticFeedback.mediumImpact();
  }
}
