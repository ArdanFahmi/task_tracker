import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: AppColors.secondaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.borderPrimary),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const Icon(SolarIconsOutline.danger, color: AppColors.error500, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.darkSecondary, fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
