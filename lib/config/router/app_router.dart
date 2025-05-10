import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthenticationRoute.page),
        AutoRoute(page: OTPRoute.page),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: DashboardRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: CalendarRoute.page),
        AutoRoute(page: SupportRoute.page),
        AutoRoute(page: SuccessRoute.page),
      ];
}

class Nav {
  static Future<void> push(
    BuildContext context,
    PageRouteInfo<dynamic>? route,
  ) async {
    await context.router.push(route!);
  }

  static Future<void> replaceAll(
    BuildContext context,
    List<PageRouteInfo<dynamic>> routes,
  ) async {
    await context.router.replaceAll(routes);
  }

  static Future<void> pushAndPopUntil(
    BuildContext context,
    PageRouteInfo<dynamic> route,
    String name,
  ) async {
    await context.router.pushAndPopUntil(
      route,
      predicate: (route) => route.settings.name == name,
    );
  }

  static Future<void> replace(
    BuildContext context,
    PageRouteInfo<dynamic> route,
  ) async {
    await context.router.replace(route);
  }

  // New popUntil method
  static void popUntil(BuildContext context, String routeName) {
    context.router.popUntil((route) => route.settings.name == routeName);
  }
}
