// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logbook_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogbookBodyDto _$LogbookBodyDtoFromJson(Map<String, dynamic> json) =>
    LogbookBodyDto(
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
    );

Map<String, dynamic> _$LogbookBodyDtoToJson(LogbookBodyDto instance) =>
    <String, dynamic>{
      'end_time': instance.endTime?.toIso8601String(),
    };
