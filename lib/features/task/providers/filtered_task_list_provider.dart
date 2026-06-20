import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/features/task/data/models/task.dart';
import 'package:task_tracker/features/task/providers/task_notifier.dart';
import 'task_filter_provider.dart';

final filteredTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasksAsync.whenData((tasks) {
    if (filter == null) return tasks;
    return tasks.where((t) => t.status == filter).toList();
  });
});
