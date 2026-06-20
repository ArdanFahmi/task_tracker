import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:task_tracker/features/profile/presentation/widgets/item_menu_profile.dart';
import '../../../../core/providers/app_info_provider.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final versionAsync = ref.watch(appVersionProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Icon(SolarIconsBold.usersGroupTwoRounded, size: 80, color: AppColors.borderPrimary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Text(
                    user?.userMetadata?['name'] ?? "-",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
                  ),
                  Text(
                    user?.email ?? "-",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkTertiary),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: AppColors.secondaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                shadows: const [
                  BoxShadow(color: Color(0x14000000), blurRadius: 40, offset: Offset(0, 4), spreadRadius: 2),
                ],
              ),
              child: Column(
                children: [
                  ItemMenuProfile(
                    leadingIcon: const Icon(SolarIconsOutline.settingsMinimalistic, color: AppColors.darkTertiary),
                    title: "Manage Account",
                    onTap: () {
                      // TODO: navigate ke edit profile screen
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.borderDarkSecondary, thickness: 1),
                  ),
                  ItemMenuProfile(
                    leadingIcon: const Icon(Icons.logout, color: AppColors.error500),
                    title: "Logout",
                    textColor: AppColors.error500,
                    onTap: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  versionAsync.when(
                    data: (version) => Text(
                      "v$version",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkTertiary),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
