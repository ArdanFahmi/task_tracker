import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskFormSubmittingProvider = NotifierProvider<TaskFormSubmittingNotifier, bool>(TaskFormSubmittingNotifier.new);

class TaskFormSubmittingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setSubmitting(bool value) => state = value;
}
