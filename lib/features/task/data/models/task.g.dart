// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'title': instance.title,
  'description': instance.description,
  'start_date': instance.startDate.toIso8601String(),
  'end_date': instance.endDate.toIso8601String(),
  'status': _$TaskStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.progress: 'progress',
  TaskStatus.done: 'done',
};
