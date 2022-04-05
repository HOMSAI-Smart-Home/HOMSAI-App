// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeDto _$ChangeDtoFromJson(Map<String, dynamic> json) => ChangeDto(
      DataDto.fromJson(json['data'] as Map<String, dynamic>),
      json['event_type'] as String,
      json['time_fired'] as String,
      json['origin'] as String,
      ContextEntity.fromJson(json['context'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChangeDtoToJson(ChangeDto instance) => <String, dynamic>{
      'data': instance.data.toJson(),
      'event_type': instance.eventType,
      'time_fired': instance.timeFired,
      'origin': instance.origin,
      'context': instance.context.toJson(),
    };

DataDto _$DataDtoFromJson(Map<String, dynamic> json) => DataDto(
      json['entity_id'] as String,
      json['new_state'] as Map<String, dynamic>,
      json['old_state'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$DataDtoToJson(DataDto instance) => <String, dynamic>{
      'entity_id': instance.entityId,
      'new_state': instance.newState,
      'old_state': instance.oldState,
    };
