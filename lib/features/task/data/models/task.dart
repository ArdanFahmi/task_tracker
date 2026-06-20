import 'package:json_annotation/json_annotation.dart';
import '../../../../shared/enums/task_status.dart';
part 'task.g.dart';

@JsonSerializable()
class Task {
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  final String title;
  final String? description;

  @JsonKey(name: 'start_date')
  final DateTime startDate;

  @JsonKey(name: 'end_date')
  final DateTime endDate;

  final TaskStatus status;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Map<String, dynamic> toInsertMap() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status.dbValue,
    };
  }

  Task copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    TaskStatus? status,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
