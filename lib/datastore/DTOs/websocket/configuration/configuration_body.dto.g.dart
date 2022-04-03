// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationBodyDto _$ConfigurationBodyDtoFromJson(
        Map<String, dynamic> json) =>
    ConfigurationBodyDto(
      json['trigger'] as Map<String, dynamic>?,
      json['condition'] as Map<String, dynamic>?,
      json['action'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ConfigurationBodyDtoToJson(
        ConfigurationBodyDto instance) =>
    <String, dynamic>{
      'trigger': instance.trigger,
      'condition': instance.condition,
      'action': instance.action,
    };
