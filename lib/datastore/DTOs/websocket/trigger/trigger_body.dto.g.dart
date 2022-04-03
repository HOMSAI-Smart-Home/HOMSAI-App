// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TriggerBodyDto _$TriggerBodyDtoFromJson(Map<String, dynamic> json) =>
    TriggerBodyDto(
      json['state'] as String,
      json['entityId'] as String,
      json['from'] as String,
      json['to'] as String,
    );

Map<String, dynamic> _$TriggerBodyDtoToJson(TriggerBodyDto instance) =>
    <String, dynamic>{
      'state': instance.state,
      'entityId': instance.entityId,
      'from': instance.from,
      'to': instance.to,
    };
