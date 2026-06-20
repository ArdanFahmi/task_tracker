import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/task.dart';
import '../data/repositories/task_repository.dart';
import '../../../shared/enums/task_status.dart';

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);

class TaskNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final repo = ref.watch(taskRepositoryProvider);
    return repo.fetchTasks();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(taskRepositoryProvider).fetchTasks());
  }

  Future<void> addTask(Task newTask) async {
    final repo = ref.read(taskRepositoryProvider);
    final created = await repo.createTask(newTask);

    final currentTasks = state.value ?? [];
    state = AsyncData([created, ...currentTasks]);
  }

  Future<void> updateStatus(String taskId, TaskStatus newStatus) async {
    final currentTasks = state.value ?? [];

    state = AsyncData([
      for (final task in currentTasks)
        if (task.id == taskId) task.copyWith(status: newStatus) else task,
    ]);

    try {
      await ref.read(taskRepositoryProvider).updateStatus(taskId, newStatus);
    } catch (e) {
      state = AsyncData(currentTasks);
      rethrow;
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    final currentTasks = state.value ?? [];

    state = AsyncData([
      for (final task in currentTasks)
        if (task.id == updatedTask.id) updatedTask else task,
    ]);

    try {
      await ref.read(taskRepositoryProvider).updateTask(updatedTask);
    } catch (e) {
      state = AsyncData(currentTasks);
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    final currentTasks = state.value ?? [];

    state = AsyncData(currentTasks.where((t) => t.id != taskId).toList());

    try {
      await ref.read(taskRepositoryProvider).deleteTask(taskId);
    } catch (e) {
      state = AsyncData(currentTasks);
      rethrow;
    }
  }
}
