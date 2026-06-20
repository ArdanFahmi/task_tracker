import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showCustomSnackbar(String title, String body, ToastificationType type) {
  toastification.show(
    type: type,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 4),
    title: Text(title),
    description: Text(body),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },

    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [BoxShadow(color: Color(0x07000000), blurRadius: 16, offset: Offset(0, 16), spreadRadius: 0)],
    showProgressBar: false,

    closeOnClick: true,
    pauseOnHover: false,
    dragToClose: true,
    applyBlurEffect: false,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => debugPrint('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) => {toastification.dismissById(toastItem.id)},
      onAutoCompleteCompleted: (toastItem) => debugPrint('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => debugPrint('Toast ${toastItem.id} dismissed'),
    ),
  );
}
