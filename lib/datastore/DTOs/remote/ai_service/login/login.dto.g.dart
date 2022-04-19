// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
      json['code'] as int?,
      json['message'] as String?,
      json['token'] as String?,
      json['refreshToken'] as String?,
    );

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
