import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:producty/config/theme/theme.dart';
import 'package:producty/feature/auth/application/auth_manager.dart';

import 'config/router/app_router.dart';
import 'config/theme/theme_provider.dart';
import 'feature/auth/data/model/auth_session_adapter.dart';
import 'feature/auth/data/model/user_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayStyle);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();

  Hive
    ..registerAdapter(AuthSessionAdapter())
    ..registerAdapter(UserAdapter())
    ..registerAdapter(UsagePurposeAdapter())
    ..registerAdapter(LoginProviderAdapter());

  await AuthManager.instance.init();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        title: 'Producty',
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ),
    );
  }
}

// bamideledavid.femi@gmail.com

/*
 ChangeNotifierProvider(create: (_) => TodoProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => DailyRoutineProvider()),
 */
/*
 onGenerateRoute: (settings) {
        if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) => OTPScreen(
                email: args['email'] as String,
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
        '/auth': (context) => const AuthenticationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/support': (context) => const SupportScreen(),
      },
 */
