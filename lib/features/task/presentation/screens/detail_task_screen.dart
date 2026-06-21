import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/error/failure.dart';
import 'package:task_tracker/core/utils/date_formatter.dart';
import 'package:task_tracker/core/utils/dialog_helper.dart';
import 'package:task_tracker/core/widgets/custom_appbar.dart';
import 'package:task_tracker/core/widgets/error_view.dart';
import 'package:task_tracker/core/widgets/info_empty_data.dart';
import 'package:task_tracker/core/widgets/main_chips.dart';
import 'package:task_tracker/core/widgets/menu_item_tile.dart';
import 'package:task_tracker/features/task/presentation/screens/form_task_screen.dart';
import 'package:task_tracker/features/task/providers/task_notifier.dart';
import 'package:task_tracker/shared/enums/task_status.dart';

import '../../data/models/task.dart';

class DetailTaskScreen extends ConsumerWidget {
  final String taskId;
  const DetailTaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: CustomAppbar(
        title: "TaskFlow",
        onBackPressed: () {
          Navigator.pop(context);
        },
        enableBackPressed: true,
        centerTitle: false,
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: ErrorView(message: getThrowErrorMsg(err))),
        data: (tasks) {
          final task = tasks.where((t) => t.id == taskId).firstOrNull;

          if (task == null) {
            return const Center(child: InfoEmptyData(title: "Task not found"));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildChipStatus(task),
                      const SizedBox(width: 4),
                      Text(
                        formatRelativeTime(task.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutralColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
                  ),
                  const SizedBox(height: 20),
                  _buildDescriptionContainer(task),
                  const SizedBox(height: 20),
                  _buildActionContainer(context, ref, task),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChipStatus(Task task) {
    switch (task.status) {
      case TaskStatus.todo:
        return const MainChips(
          title: "Todo",
          colorBadge: AppColors.borderDarkSecondary,
          colorTitle: AppColors.neutralColor,
          paddingHorizontal: 12,
          paddingVertical: 6,
          radius: 8,
          enableBorder: false,
        );
      case TaskStatus.progress:
        return const MainChips(
          title: "Progress",
          colorBadge: AppColors.primary200,
          colorTitle: AppColors.primaryColor,
          paddingHorizontal: 12,
          paddingVertical: 6,
          radius: 8,
          enableBorder: false,
        );
      case TaskStatus.done:
        return const MainChips(
          title: "Done",
          colorBadge: AppColors.success500,
          colorTitle: AppColors.secondaryColor,
          paddingHorizontal: 12,
          paddingVertical: 6,
          radius: 8,
          enableBorder: false,
        );
    }
  }

  Widget _buildDescriptionContainer(Task task) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: AppColors.borderPrimary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
          ),
          const SizedBox(height: 8),
          Text(
            task.description?.isNotEmpty == true ? task.description! : '-',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.neutralColor),
          ),
        ],
      ),
    );
  }

  Widget _buildActionContainer(BuildContext ctx, WidgetRef ref, Task task) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: AppColors.borderPrimary, width: 1),
      ),
      child: Column(
        children: [
          MenuItemTile(
            leadingIcon: const Icon(SolarIconsOutline.pen, color: AppColors.primaryColor),
            title: "Edit Task",
            onTap: () {
              Navigator.push(ctx, MaterialPageRoute(builder: (context) => FormTaskScreen(existingTask: task)));
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.borderDarkSecondary, thickness: 1),
          ),
          MenuItemTile(
            leadingIcon: const Icon(SolarIconsOutline.trashBinTrash, color: AppColors.error500),
            title: "Delete Task",
            textColor: AppColors.error500,
            onTap: () async {
              final confirmed = await showDeleteConfirmationDialog(ctx);
              if (!confirmed) return;

              await ref.read(taskProvider.notifier).deleteTask(task.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
