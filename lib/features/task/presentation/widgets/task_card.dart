import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/utils/dialog_helper.dart';
import 'package:task_tracker/core/widgets/custom_snackbar.dart';
import 'package:task_tracker/features/task/data/models/task.dart';
import 'package:task_tracker/features/task/presentation/screens/form_task_screen.dart';
import 'package:task_tracker/features/task/presentation/widgets/task_badge.dart';
import 'package:task_tracker/features/task/providers/task_notifier.dart';
import 'package:task_tracker/shared/enums/task_status.dart';
import 'package:toastification/toastification.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = _isOverdue(task.endDate, task.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: AppColors.borderPrimary, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusDropdown(task: task),
                PopupMenuButton<String>(
                  icon: const Icon(SolarIconsBold.menuDots, color: AppColors.darkTertiary),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormTaskScreen(existingTask: task)),
                      );
                    } else if (value == 'delete') {
                      if (isOverdue) {
                        return showCustomSnackbar(
                          "Failed to delete task",
                          "Your task is overdue",
                          ToastificationType.error,
                        );
                      } else if (task.status == TaskStatus.done) {
                        return showCustomSnackbar(
                          "Failed to delete task",
                          "Your task is already done",
                          ToastificationType.error,
                        );
                      }

                      final confirmed = await showDeleteConfirmationDialog(context);
                      if (!confirmed) return;

                      ref.read(taskProvider.notifier).deleteTask(task.id);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
            ),
            Text(
              task.description ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.neutralColor),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (isOverdue)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(SolarIconsBold.danger, size: 16, color: AppColors.error500),
                  ),
                Text(
                  _formatDate(task.endDate),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isOverdue ? AppColors.error500 : AppColors.neutralColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isOverdue(DateTime endDate, TaskStatus status) {
    if (status == TaskStatus.done) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return end.isBefore(today);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    return isToday ? "Today" : "${date.day}/${date.month}/${date.year}";
  }
}

class _StatusDropdown extends ConsumerWidget {
  final Task task;
  const _StatusDropdown({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = task.status == TaskStatus.done;

    return PopupMenuButton<TaskStatus>(
      enabled: !isLocked,
      offset: const Offset(0, 32),
      onSelected: (newStatus) {
        if (newStatus == task.status) return;
        ref.read(taskProvider.notifier).updateStatus(task.id, newStatus);
      },
      itemBuilder: (context) => TaskStatus.values.map((status) {
        return PopupMenuItem(
          value: status,
          child: Row(
            children: [
              if (status == task.status)
                const Icon(Icons.check, size: 16, color: AppColors.primaryColor)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(status.label),
            ],
          ),
        );
      }).toList(),
      child: StatusBadge(status: task.status),
    );
  }
}
