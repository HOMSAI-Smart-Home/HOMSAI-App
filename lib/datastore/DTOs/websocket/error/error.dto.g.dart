// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorDto _$ErrorDtoFromJson(Map<String, dynamic> json) => ErrorDto(
      json['code'] as int?,
      json['message'] as String?,
    );

Map<String, dynamic> _$ErrorDtoToJson(ErrorDto instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
