import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'dbValue')
enum TaskStatus {
  todo('todo'),
  progress('progress'),
  done('done');

  final String dbValue;
  const TaskStatus(this.dbValue);
}

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.todo:
        return "Todo";
      case TaskStatus.progress:
        return "Progress";
      case TaskStatus.done:
        return "Done";
    }
  }
}
