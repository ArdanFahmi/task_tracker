import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/error/failure.dart';
import 'package:task_tracker/core/widgets/custom_snackbar.dart';
import 'package:task_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:task_tracker/features/auth/providers/auth_provider.dart';
import 'package:task_tracker/features/home/presentation/screens/menu.dart';
import 'package:toastification/toastification.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      final authNotifier = ref.read(authProvider.notifier);
      await ref.read(authProvider.future);

      if (!mounted) return;

      if (authNotifier.isValid) {
        Navigator.pushNamedAndRemoveUntil(context, Menu.routeName, (route) => false);
      } else {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    } catch (e) {
      final err = getThrowErrorMsg(e);
      showCustomSnackbar("There is problem", err, ToastificationType.error);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: AppColors.borderPrimary, width: 1),
              ),
              child: Image.asset("assets/icons/app_icon.png", height: screenHeight * 0.15),
            ),
            const SizedBox(height: 16),
            const Text(
              'TaskFlow',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
            ),
            const Text(
              'Simplifying your productivity.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
