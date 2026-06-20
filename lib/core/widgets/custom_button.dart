import 'package:flutter/material.dart';
import 'package:task_tracker/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color btnColor;
  final Color colorTitle;
  final Color? borderColor;
  final bool enableBorder;
  final bool isLoading;
  final double paddingVerticalContent;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.btnColor,
    required this.colorTitle,
    this.borderColor,
    this.enableBorder = false,
    this.isLoading = false,
    required this.paddingVerticalContent,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        decoration: ShapeDecoration(
          color: isLoading ? AppColors.borderPrimary : btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: enableBorder ? BorderSide(color: borderColor!, width: 2.0) : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: paddingVerticalContent, horizontal: 24),
          child: Center(
            child: isLoading
                ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: colorTitle))
                : Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorTitle, fontSize: fontSize, fontWeight: FontWeight.w500),
                  ),
          ),
        ),
      ),
    );
  }
}
