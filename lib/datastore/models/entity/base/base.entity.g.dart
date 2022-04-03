// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map<String, dynamic> json) => Entity(
      json['entity_id'] as String,
    );

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'entity_id': instance.entityId,
    };

TogglableEntity _$TogglableEntityFromJson(Map<String, dynamic> json) =>
    TogglableEntity(
      json['entity_id'] as String,
      json['state'] as String,
    );

Map<String, dynamic> _$TogglableEntityToJson(TogglableEntity instance) =>
    <String, dynamic>{
      'entity_id': instance.entityId,
      'state': instance.state,
    };
