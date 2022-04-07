// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryDto _$HistoryDtoFromJson(Map<String, dynamic> json) => HistoryDto(
      (json['entitysHistory'] as List<dynamic>)
          .map((e) => EntitysHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistoryDtoToJson(HistoryDto instance) =>
    <String, dynamic>{
      'entitysHistory': instance.entitysHistory.map((e) => e.toJson()).toList(),
    };

EntitysHistory _$EntitysHistoryFromJson(Map<String, dynamic> json) =>
    EntitysHistory(
      (json['changes'] as List<dynamic>)
          .map((e) => ChangeAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntitysHistoryToJson(EntitysHistory instance) =>
    <String, dynamic>{
      'changes': instance.changes.map((e) => e.toJson()).toList(),
    };

ChangeAttribute _$ChangeAttributeFromJson(Map<String, dynamic> json) =>
    ChangeAttribute(
      json['attributes'] as Map<String, dynamic>?,
      json['entity_id'] as String?,
      const DateTimeConverter().fromJson(json['last_changed'] as String),
      json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      json['state'] as String,
    );

Map<String, dynamic> _$ChangeAttributeToJson(ChangeAttribute instance) =>
    <String, dynamic>{
      'attributes': instance.attributes,
      'entity_id': instance.entityId,
      'last_changed': const DateTimeConverter().toJson(instance.lastChanged),
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'state': instance.state,
    };
