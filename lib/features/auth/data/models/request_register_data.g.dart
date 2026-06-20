// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_register_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestRegisterData _$RequestRegisterDataFromJson(Map<String, dynamic> json) =>
    RequestRegisterData(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$RequestRegisterDataToJson(
  RequestRegisterData instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
};
