// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_related.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRelatedDto _$DeviceRelatedDtoFromJson(Map<String, dynamic> json) =>
    DeviceRelatedDto(
      area: (json['area'] as List<dynamic>?)?.map((e) => e as String).toList(),
      configEntry: (json['config_entry'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      entity:
          (json['entity'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DeviceRelatedDtoToJson(DeviceRelatedDto instance) =>
    <String, dynamic>{
      'area': instance.area,
      'config_entry': instance.configEntry,
      'entity': instance.entity,
    };
