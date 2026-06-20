import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/supabase/supabase_client_provider.dart';
import '../../../../shared/enums/task_status.dart';
import '../models/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TaskRepository(client);
});

class TaskRepository {
  final SupabaseClient _client;
  TaskRepository(this._client);

  /// Tidak perlu pakai where user_id karena sudah ada config RLS di Supabase
  /// yang menyatakan bahwa hanya User tersebut yang bisa melihat datanya sendiri
  Future<List<Task>> fetchTasks() async {
    final response = await _client.from('tasks').select().eq('is_deleted', false).order('created_at', ascending: false);

    return (response as List).map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> createTask(Task task) async {
    final response = await _client.from('tasks').insert(task.toInsertMap()).select().single();

    return Task.fromJson(response);
  }

  Future<void> updateStatus(String taskId, TaskStatus status) async {
    await _client
        .from('tasks')
        .update({'status': status.dbValue, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', taskId);
  }

  Future<void> updateTask(Task task) async {
    await _client
        .from('tasks')
        .update({
          'title': task.title,
          'description': task.description,
          'start_date': task.startDate.toIso8601String(),
          'end_date': task.endDate.toIso8601String(),
          'status': task.status.dbValue,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', task.id);
  }

  Future<void> deleteTask(String taskId) async {
    await _client
        .from('tasks')
        .update({'is_deleted': true, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', taskId);
  }
}
