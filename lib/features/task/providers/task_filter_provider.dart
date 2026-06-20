import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/enums/task_status.dart';

final taskFilterProvider = NotifierProvider<TaskFilterNotifier, TaskStatus?>(TaskFilterNotifier.new);

class TaskFilterNotifier extends Notifier<TaskStatus?> {
  @override
  TaskStatus? build() => null;

  void setFilter(TaskStatus? status) {
    state = status;
  }
}
