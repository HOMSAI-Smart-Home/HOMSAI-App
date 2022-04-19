// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryDto _$HistoryDtoFromJson(Map<String, dynamic> json) => HistoryDto(
      json['attributes'] as Map<String, dynamic>?,
      json['entity_id'] as String?,
      const DateTimeConverter().fromJson(json['last_changed'] as String),
      json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      json['state'] as String,
    );

Map<String, dynamic> _$HistoryDtoToJson(HistoryDto instance) =>
    <String, dynamic>{
      'attributes': instance.attributes,
      'entity_id': instance.entityId,
      'last_changed': const DateTimeConverter().toJson(instance.lastChanged),
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'state': instance.state,
    };
