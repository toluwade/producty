import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPinField extends StatelessWidget {
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final int length;
  final bool autoDisposeControllers;
  final StreamController<ErrorAnimationType>? errorController;

  const OtpPinField({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.autoDisposeControllers = false,
    this.errorController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return PinCodeTextField(
      appContext: context,
      length: length,
      controller: controller,
      autoDisposeControllers: autoDisposeControllers,
      errorAnimationController: errorController,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      cursorColor: primary,
      animationDuration: const Duration(milliseconds: 200),
      enableActiveFill: true,
      onCompleted: onCompleted,
      onChanged: onChanged,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 56,
        fieldWidth: 50,
        borderWidth: 0.5,
        activeBorderWidth: 0.5,
        selectedBorderWidth: 1,
        inactiveBorderWidth: 0,
        activeColor: Colors.transparent,
        selectedColor: primary.withValues(alpha: .1),
        inactiveColor: Colors.grey.shade400,
        activeFillColor: primary.withValues(alpha: .05),
        selectedFillColor: primary.withValues(alpha: .1),
        inactiveFillColor: Colors.grey.shade100,
      ),
    );
  }
}
