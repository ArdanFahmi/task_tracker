import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onBackPressed;
  final Widget? actionComponent, leadingComponent;
  final bool? enableBackPressed;
  final bool? centerTitle;

  const CustomAppbar({
    super.key,
    required this.title,
    required this.onBackPressed,
    this.actionComponent,
    this.leadingComponent,
    this.enableBackPressed = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: AppColors.primaryColor, fontSize: 24, fontWeight: FontWeight.w700),
      ),
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.surfaceColor,
      surfaceTintColor: AppColors.surfaceColor,
      leading:
          leadingComponent ??
          (enableBackPressed == true
              ? IconButton(
                  onPressed: onBackPressed as void Function(),
                  icon: const Icon(SolarIconsOutline.arrowLeft, color: AppColors.primaryColor),
                )
              : null),
      actions: actionComponent != null ? [actionComponent!] : null,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.borderPrimary),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
