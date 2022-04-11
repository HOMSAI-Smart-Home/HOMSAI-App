// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LightEntity _$LightEntityFromJson(Map<String, dynamic> json) => LightEntity(
      json['entity_id'] as String,
      json['state'] as String,
      LightAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
      DateTime.parse(json['last_changed'] as String),
      DateTime.parse(json['last_updated'] as String),
      ContextEntity.fromJson(json['context'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LightEntityToJson(LightEntity instance) =>
    <String, dynamic>{
      'entity_id': instance.entityId,
      'state': instance.state,
      'last_changed': instance.lastChanged.toIso8601String(),
      'last_updated': instance.lastUpdated.toIso8601String(),
      'context': instance.context.toJson(),
      'attributes': instance.attributes.toJson(),
    };

LightAttributes _$LightAttributesFromJson(Map<String, dynamic> json) =>
    LightAttributes(
      json['friendly_name'] as String,
    )
      ..colorMode = json['color_mode'] as String?
      ..colorTemp = json['color_temp'] as int?
      ..brightness = json['brightness'] as int?
      ..effect = json['effect'] as String?
      ..effectList = json['effect_list'] as List<dynamic>?
      ..hsColor = json['hs_color'] as List<dynamic>?
      ..maxMireds = json['max_mireds'] as int?
      ..minMireds = json['min_mireds'] as int?
      ..xyColor = json['xy_color'] as List<dynamic>?
      ..rgbColor = json['rgb_color'] as List<dynamic>?
      ..rgbwColor = json['rgbw_color'] as List<dynamic>?
      ..rgbwwColor = json['rgbww_color'] as List<dynamic>?
      ..supportedColorModes = json['supported_color_modes'] as List<dynamic>?
      ..supportedFeatures = json['supported_features'] as int?;

Map<String, dynamic> _$LightAttributesToJson(LightAttributes instance) =>
    <String, dynamic>{
      'friendly_name': instance.friendlyName,
      'color_mode': instance.colorMode,
      'color_temp': instance.colorTemp,
      'brightness': instance.brightness,
      'effect': instance.effect,
      'effect_list': instance.effectList,
      'hs_color': instance.hsColor,
      'max_mireds': instance.maxMireds,
      'min_mireds': instance.minMireds,
      'xy_color': instance.xyColor,
      'rgb_color': instance.rgbColor,
      'rgbw_color': instance.rgbwColor,
      'rgbww_color': instance.rgbwwColor,
      'supported_color_modes': instance.supportedColorModes,
      'supported_features': instance.supportedFeatures,
    };
