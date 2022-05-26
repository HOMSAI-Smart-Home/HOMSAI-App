// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDto _$DeviceDtoFromJson(Map<String, dynamic> json) => DeviceDto(
      id: json['id'] as String,
      area: json['areaId'] as String?,
      configurationUrl: json['configuration_url'] as String?,
      configEntries: (json['config_entries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      connections: json['connections'] as List<dynamic>?,
      disabledBy: json['disabled_by'],
      entryType: json['entry_type'],
      identifiers: json['identifiers'] as List<dynamic>,
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      nameByUser: json['name_by_user'] as String?,
      name: json['name'] as String,
      swVersion: json['sw_version'],
      hwVersion: json['hw_version'],
      viaDeviceId: json['via_device_id'],
    );

Map<String, dynamic> _$DeviceDtoToJson(DeviceDto instance) => <String, dynamic>{
      'id': instance.id,
      'areaId': instance.area,
      'configuration_url': instance.configurationUrl,
      'config_entries': instance.configEntries,
      'connections': instance.connections,
      'disabled_by': instance.disabledBy,
      'entry_type': instance.entryType,
      'identifiers': instance.identifiers,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'name_by_user': instance.nameByUser,
      'name': instance.name,
      'sw_version': instance.swVersion,
      'hw_version': instance.hwVersion,
      'via_device_id': instance.viaDeviceId,
    };
