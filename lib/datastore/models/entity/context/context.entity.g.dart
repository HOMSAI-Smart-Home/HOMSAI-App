// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextEntity _$ContextEntityFromJson(Map<String, dynamic> json) =>
    ContextEntity(
      json['id'] as String,
      json['parent_id'] as String?,
      json['user_id'] as String?,
    );

Map<String, dynamic> _$ContextEntityToJson(ContextEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'user_id': instance.userId,
    };
