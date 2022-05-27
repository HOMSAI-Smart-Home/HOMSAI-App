// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map<String, dynamic> json) => Entity(
      json['entity_id'] as String,
      json['state'] as String,
      Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
      DateTime.parse(json['last_changed'] as String),
      DateTime.parse(json['last_updated'] as String),
      ContextEntity.fromJson(json['context'] as Map<String, dynamic>),
      area: json['area'] == null
          ? null
          : Area.fromJson(json['area'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'entity_id': instance.entityId,
      'area': instance.area?.toJson(),
      'state': instance.state,
      'attributes': instance.attributes.toJson(),
      'last_changed': instance.lastChanged.toIso8601String(),
      'last_updated': instance.lastUpdated.toIso8601String(),
      'context': instance.context.toJson(),
    };
