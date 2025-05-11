import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:producty/config/router/app_router.gr.dart';

import '../../../../config/router/app_router.dart';
import '../../../auth/application/auth_manager.dart';

@RoutePage()
class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  // Original logo dimensions
  static const double _originalWidth = 207;
  static const double _originalHeight = 58.33;
  static const double _aspectRatio = _originalWidth / _originalHeight;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 2000),
    );

    final fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ).drive(Tween<double>(begin: 0.0, end: 1.0));

    final scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ).drive(Tween<double>(begin: 0.8, end: 1.0));

    useEffect(() {
      controller.forward().then((_) async {
        final isLoggedIn = AuthManager.instance.isLoggedIn;

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!context.mounted) return;

          if (isLoggedIn) {
            Nav.push(context, const DashboardRoute());
          } else {
            Nav.push(context, const AuthenticationRoute());
          }
        });
      });

      return null; // cleanup not needed
    }, const []);

    // Calculate responsive width (55% of screen width)
    final logoWidth = size.width * 0.55;
    final logoHeight = logoWidth / _aspectRatio;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: SvgPicture.asset(
              isDarkMode
                  ? 'assets/images/darkLogo.svg'
                  : 'assets/images/lightLogo.svg',
              width: logoWidth,
              height: logoHeight,
            ),
          ),
        ),
      ),
    );
  }
}
