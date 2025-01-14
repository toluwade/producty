import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/success_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/dashboard/profile_screen.dart';
import 'screens/dashboard/calendar_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/support/support_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro design size
      builder: (_, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TodoProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              title: 'Producty',
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              theme: ThemeData(
                colorScheme: ColorScheme.light(
                  primary: Colors.black,
                  secondary: Colors.grey[900]!,
                  surface: Colors.white,
                  surfaceContainerHighest: const Color(0xFFF9F9F9),
                ),
                scaffoldBackgroundColor: const Color(0xFFF9F9F9),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                    systemNavigationBarColor: Colors.transparent,
                    systemNavigationBarIconBrightness: Brightness.dark,
                    systemNavigationBarDividerColor: Colors.transparent,
                    systemNavigationBarContrastEnforced: false,
                  ),
                  iconTheme: IconThemeData(color: Colors.black),
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: Colors.white,
                  secondary: Colors.grey[300]!,
                  surface: Colors.grey[900]!,
                  surfaceContainerHighest: Colors.black,
                ),
                scaffoldBackgroundColor: Colors.black,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.dark,
                    systemNavigationBarColor: Colors.transparent,
                    systemNavigationBarIconBrightness: Brightness.light,
                    systemNavigationBarDividerColor: Colors.transparent,
                    systemNavigationBarContrastEnforced: false,
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                useMaterial3: true,
              ),
              onGenerateRoute: (settings) {
                if (settings.name == '/otp') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => OTPScreen(
                      email: args['email'] as String,
                      isExisting: args['isExisting'] as bool,
                    ),
                  );
                } else if (settings.name == '/success') {
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (context) => SuccessScreen(
                      isExisting: args['isExisting'] as bool,
                    ),
                  );
                }
                return null;
              },
              routes: {
                '/': (context) => const SplashScreen(),
                '/onboarding': (context) => const OnboardingScreen(),
                '/auth': (context) => const AuthScreen(),
                '/dashboard': (context) => const DashboardScreen(),
                '/profile': (context) => const ProfileScreen(),
                '/calendar': (context) => const CalendarScreen(),
                '/support': (context) => const SupportScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
