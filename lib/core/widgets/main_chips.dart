import 'package:flutter/material.dart';

class MainChips extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Color colorBadge, colorTitle;
  final double paddingHorizontal, paddingVertical, radius;
  final bool enableBorder;
  final Color? borderColor;
  const MainChips({
    super.key,
    required this.title,
    this.icon,
    required this.colorBadge,
    required this.colorTitle,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.radius,
    required this.enableBorder,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
      decoration: ShapeDecoration(
        color: colorBadge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(radius),
          side: enableBorder ? BorderSide(color: borderColor!, width: 1.0) : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 4)],
          Text(
            title,
            style: TextStyle(color: colorTitle, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
