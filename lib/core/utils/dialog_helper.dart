import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  String title = 'Delete Task',
  String message = 'Are you sure you want to delete this task?',
}) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete', style: TextStyle(color: AppColors.error500)),
        ),
      ],
    ),
  );

  return confirm ?? false;
}
