// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseDto _$ResponseDtoFromJson(Map<String, dynamic> json) => ResponseDto(
      json['id'] as int,
      json['type'] as String,
      json['success'] as bool?,
      json['result'],
    )
      ..error = json['error'] == null
          ? null
          : ErrorDto.fromJson(json['error'] as Map<String, dynamic>)
      ..event = json['event'] as Map<String, dynamic>?;

Map<String, dynamic> _$ResponseDtoToJson(ResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'success': instance.success,
      'result': instance.result,
      'error': instance.error?.toJson(),
      'event': instance.event,
    };
