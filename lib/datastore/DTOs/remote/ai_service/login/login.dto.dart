import 'package:json_annotation/json_annotation.dart';

part 'login.dto.g.dart';

@JsonSerializable()
class LoginDto {
  int? code;
  String? message;
  String? token;
  String? refreshToken;

  LoginDto(this.code, this.message, this.token, this.refreshToken);

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}
