import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/core/constants/app_colors.dart';
import 'package:task_tracker/core/error/failure.dart';
import 'package:task_tracker/core/widgets/custom_appbar.dart';
import 'package:task_tracker/core/widgets/error_view.dart';
import 'package:task_tracker/core/widgets/info_empty_data.dart';
import 'package:task_tracker/features/profile/providers/user_provider.dart';
import 'package:task_tracker/features/task/presentation/widgets/task_card.dart';
import 'package:task_tracker/features/task/presentation/widgets/task_filter_bar.dart';
import 'package:task_tracker/features/task/providers/filtered_task_list_provider.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: CustomAppbar(title: "TaskFlow", onBackPressed: () {}, enableBackPressed: false, centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello ${user?.userMetadata?['name'] ?? "-"}.",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.neutralColor),
            ),
            const SizedBox(height: 8),
            Text(
              "Keeping my fingers crossed for you—hope you have a lovely day!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.neutralColor),
            ),
            const SizedBox(height: 20),
            TaskFilterBar(),
            const SizedBox(height: 20),
            Expanded(child: _buildListTask()),
          ],
        ),
      ),
    );
  }

  Widget _buildListTask() {
    final filteredTasks = ref.watch(filteredTaskListProvider);
    return filteredTasks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: ErrorView(message: getThrowErrorMsg(err))),
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Center(
            child: InfoEmptyData(
              title: "Your task is empty",
              subTitle: "You can create a new task by clicking the + button belows",
            ),
          );
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) => TaskCard(task: tasks[index]),
        );
      },
    );
  }
}
