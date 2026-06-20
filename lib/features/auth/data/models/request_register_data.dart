import 'package:json_annotation/json_annotation.dart';
part 'request_register_data.g.dart';

@JsonSerializable()
class RequestRegisterData {
  final String email;
  final String password;
  final String name;

  RequestRegisterData({required this.email, required this.password, required this.name});
  factory RequestRegisterData.fromJson(Map<String, dynamic> json) => _$RequestRegisterDataFromJson(json);
  Map<String, dynamic> toJson() => _$RequestRegisterDataToJson(this);
}
