// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogDto _$LogDtoFromJson(Map<String, dynamic> json) => LogDto(
      json['state'] as String?,
      json['entity_id'] as String?,
      json['name'] as String?,
      const DateTimeConverter().fromJson(json['when'] as String),
    );

Map<String, dynamic> _$LogDtoToJson(LogDto instance) => <String, dynamic>{
      'state': instance.state,
      'entity_id': instance.entityId,
      'name': instance.name,
      'when': const DateTimeConverter().toJson(instance.when),
    };
