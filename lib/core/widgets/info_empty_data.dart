import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task_tracker/core/constants/app_colors.dart';

class InfoEmptyData extends StatelessWidget {
  final String title;
  final String? subTitle;

  const InfoEmptyData({super.key, required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Lottie.asset('assets/gif/empty_box.json'),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.neutralColor, fontSize: 14, fontWeight: FontWeight.w700),
        ),
        if (subTitle != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              subTitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.darkSecondary, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}
