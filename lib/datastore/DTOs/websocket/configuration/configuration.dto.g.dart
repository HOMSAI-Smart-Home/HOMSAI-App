// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationDto _$ConfigurationDtoFromJson(Map<String, dynamic> json) =>
    ConfigurationDto(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      locationName: json['location_name'] as String,
      version: json['version'] as String,
      state: json['state'] as String,
      currency: json['currency'] as String,
      source: json['config_source'] as String,
      dir: json['config_dir'] as String,
      timezone: json['time_zone'] as String,
      isSafeMode: json['safe_mode'] as bool,
      whitelistExternalDirs: (json['whitelist_external_dirs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allowExternalDirs: (json['allowlist_external_dirs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allowExternalUrls: (json['allowlist_external_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      components: (json['components'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      unitSystem: Map<String, String>.from(json['unit_system'] as Map),
      externalUrl: json['external_url'] as String?,
      internalUrl: json['internal_url'] as String?,
    );

Map<String, dynamic> _$ConfigurationDtoToJson(ConfigurationDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'elevation': instance.elevation,
      'location_name': instance.locationName,
      'version': instance.version,
      'state': instance.state,
      'currency': instance.currency,
      'config_source': instance.source,
      'config_dir': instance.dir,
      'time_zone': instance.timezone,
      'safe_mode': instance.isSafeMode,
      'external_url': instance.externalUrl,
      'internal_url': instance.internalUrl,
      'whitelist_external_dirs': instance.whitelistExternalDirs,
      'allowlist_external_dirs': instance.allowExternalDirs,
      'allowlist_external_urls': instance.allowExternalUrls,
      'components': instance.components,
      'unit_system': instance.unitSystem,
    };
