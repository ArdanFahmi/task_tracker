import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

InputDecoration buildInputDecoration({required String hintText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(16),
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkTertiary),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(4),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.borderPrimary),
      borderRadius: BorderRadius.circular(4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColors.error500),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
    errorStyle: const TextStyle(color: AppColors.error500, fontSize: 12),
  );
}
