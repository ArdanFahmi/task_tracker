import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/enums/task_status.dart';

class StatusBadge extends StatelessWidget {
  final TaskStatus status;
  const StatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.borderPrimary;
      case TaskStatus.progress:
        return AppColors.primary200;
      case TaskStatus.done:
        return AppColors.success500;
    }
  }

  Color get _textColor {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.neutralColor;
      case TaskStatus.progress:
        return AppColors.primaryColor;
      case TaskStatus.done:
        return AppColors.success500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: _bgColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status.label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textColor),
          ),
          const SizedBox(width: 4),
          Icon(SolarIconsBold.altArrowDown, color: _textColor),
        ],
      ),
    );
  }
}
