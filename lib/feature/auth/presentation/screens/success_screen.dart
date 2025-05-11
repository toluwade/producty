import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/router/app_router.dart';
import '../../../../config/router/app_router.gr.dart';

@RoutePage()
class SuccessScreen extends StatelessWidget {
  final bool isExisting;

  const SuccessScreen({
    super.key,
    required this.isExisting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF28282A) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 200,
                height: 200,
                repeat: false,
              ),
              const SizedBox(height: 32),
              Text(
                isExisting ? 'Welcome Back!' : 'Welcome to Producty!',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: isDark ? Colors.white : const Color(0xFF3D3D3D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                isExisting
                    ? 'Great to see you again! Your workspace is ready.'
                    : 'Your account has been created successfully.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? const Color(0xFF7B7B80)
                      : const Color(0xFF616161),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isExisting) {
                      Nav.replaceAll(context, [const DashboardRoute()]);
                    } else {
                      Nav.replaceAll(context, [
                        const AuthenticationRoute(),
                        const OnboardingRoute(),
                      ]);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D3D3D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
