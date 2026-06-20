import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/navigation/app_navigation.dart';
import 'package:task_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:task_tracker/features/auth/presentation/screens/register_screen.dart';
import 'package:task_tracker/features/home/presentation/screens/menu.dart';
import 'package:task_tracker/features/splash/presentation/screens/splash_screen.dart';
import 'package:toastification/toastification.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  var supaseUrl = dotenv.env['SUPABASE_URL'];
  var supabaseKey = dotenv.env['SUPABASE_KEY'];
  await Supabase.initialize(
    url: supaseUrl!,
    publishableKey: supabaseKey!,
    authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
  );
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToastificationWrapper(
        child: MaterialApp(
          navigatorKey: AppNavigation.navigatorKey,
          title: "Task Tracker",
          home: const SplashScreen(),
          theme: ThemeData(
            fontFamily: 'PlusJakartaSans',
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: AppColors.primaryColor,
              selectionColor: AppColors.primaryColor,
              selectionHandleColor: AppColors.primaryColor,
            ),
            scaffoldBackgroundColor: AppColors.surfaceColor,
          ),
          debugShowCheckedModeBanner: true,
          builder: (context, child) => SafeArea(child: child ?? const SizedBox.shrink()),
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            Menu.routeName: (context) => const Menu(),
          },
        ),
      ),
    );
  }
}
