import 'package:flutter/material.dart';
import 'package:task_tracker/core/constants/app_colors.dart';

class MenuItemTile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const MenuItemTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.textColor = AppColors.neutralColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          leadingIcon,
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
          ),
        ],
      ),
    );
  }
}
