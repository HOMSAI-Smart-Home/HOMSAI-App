import 'package:json_annotation/json_annotation.dart';

part 'login_body.dto.g.dart';

@JsonSerializable()
class LoginBodyDto {
  String email;

  LoginBodyDto(this.email);

  factory LoginBodyDto.fromJson(Map<String, dynamic> json) =>
      _$LoginBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginBodyDtoToJson(this);
}