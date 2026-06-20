import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/features/task/data/models/task.dart';
import 'package:task_tracker/features/task/presentation/widgets/task_badge.dart';
import 'package:task_tracker/shared/enums/task_status.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onSelected: (value) {
                  if (value == 'edit') {
                    // TODO: navigate ke edit task screen
                  } else if (value == 'delete') {
                    // TODO: call delete (soft delete is_deleted = true)
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Title",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
          ),
          Text(
            "Description",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.neutralColor),
          ),
          const SizedBox(height: 16),
          Text(
            _formatDate(task.startDate),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.neutralColor),
          ),
        ],
      ),
    );
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
    return PopupMenuButton<TaskStatus>(
      offset: const Offset(0, 32),
      onSelected: (newStatus) {
        if (newStatus == task.status) return;
        // ref.read(taskListProvider.notifier).updateStatus(task.id, newStatus);
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
