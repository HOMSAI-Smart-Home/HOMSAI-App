// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binary_sensor.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BinarySensorEntity _$BinarySensorEntityFromJson(Map<String, dynamic> json) =>
    BinarySensorEntity(
      json['entity_id'] as String,
      json['state'] as String,
      BinarySensorAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      DateTime.parse(json['last_changed'] as String),
      DateTime.parse(json['last_updated'] as String),
      ContextEntity.fromJson(json['context'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BinarySensorEntityToJson(BinarySensorEntity instance) =>
    <String, dynamic>{
      'entity_id': instance.entityId,
      'state': instance.state,
      'last_changed': instance.lastChanged.toIso8601String(),
      'last_updated': instance.lastUpdated.toIso8601String(),
      'context': instance.context.toJson(),
      'attributes': instance.attributes.toJson(),
    };

BinarySensorAttributes _$BinarySensorAttributesFromJson(
        Map<String, dynamic> json) =>
    BinarySensorAttributes(
      json['friendly_name'] as String,
      $enumDecodeNullable(_$DeviceClassEnumMap, json['device_class']) ??
          DeviceClass.unknown,
      json['icon'] as String?,
    );

Map<String, dynamic> _$BinarySensorAttributesToJson(
        BinarySensorAttributes instance) =>
    <String, dynamic>{
      'friendly_name': instance.friendlyName,
      'device_class': _$DeviceClassEnumMap[instance.deviceClass],
      'icon': instance.icon,
    };

const _$DeviceClassEnumMap = {
  DeviceClass.unknown: 'unknown',
  DeviceClass.apparentPower: 'apparent_power',
  DeviceClass.aqi: 'aqi',
  DeviceClass.battery: 'battery',
  DeviceClass.carbonDioxide: 'carbon_dioxide',
  DeviceClass.carbonMonoxide: 'carbon_monoxide',
  DeviceClass.current: 'current',
  DeviceClass.date: 'date',
  DeviceClass.energy: 'energy',
  DeviceClass.frequency: 'frequency',
  DeviceClass.gas: 'gas',
  DeviceClass.humidity: 'humidity',
  DeviceClass.illuminance: 'illuminance',
  DeviceClass.monetary: 'monetary',
  DeviceClass.nitrogenDioxide: 'nitrogen_dioxide',
  DeviceClass.nitrogenMonoxide: 'nitrogen_monoxide',
  DeviceClass.nitrousOxide: 'nitrous_oxide',
  DeviceClass.ozone: 'ozone',
  DeviceClass.pm1: 'pm1',
  DeviceClass.pm25: 'pm25',
  DeviceClass.pm10: 'pm10',
  DeviceClass.power: 'power',
  DeviceClass.powerFactor: 'power_factor',
  DeviceClass.pressure: 'pressure',
  DeviceClass.reactivePower: 'reactive_power',
  DeviceClass.signalStrength: 'signal_strength',
  DeviceClass.sulphurDioxide: 'sulphur_dioxide',
  DeviceClass.temperature: 'temperature',
  DeviceClass.timestamp: 'timestamp',
  DeviceClass.volatileOrganicCompounds: 'volatile_organic_compounds',
  DeviceClass.voltage: 'voltage',
  DeviceClass.connectivity: 'connectivity',
  DeviceClass.update: 'update',
  DeviceClass.plug: 'plug',
  DeviceClass.window: 'window',
};