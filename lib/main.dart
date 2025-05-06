import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:producty/config/theme.dart';
import 'package:producty/feature/auth/data/model/auth_session.dart';

import 'config/theme_provider.dart';
import 'feature/auth/data/model/user.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/success_screen.dart';
import 'screens/dashboard/calendar_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/dashboard/profile_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/support/support_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    AppTheme.overlayStyle,
  );

  await Hive.initFlutter();

  Hive
    ..registerAdapter(AuthSessionAdapter())
    ..registerAdapter(UserAdapter());

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the theme mode from the themeProvider
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Producty',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) => OTPScreen(
                email: args['email'] as String,
                isExisting: args['isExisting'] as bool,
              ),
            );
          }
        } else if (settings.name == '/success') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) => SuccessScreen(
                isExisting: args['isExisting'] as bool,
              ),
            );
          }
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
  }
}

/*
 ChangeNotifierProvider(create: (_) => TodoProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => DailyRoutineProvider()),
 */
