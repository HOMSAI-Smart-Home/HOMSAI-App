// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationDto _$ConfigurationDtoFromJson(Map<String, dynamic> json) =>
    ConfigurationDto(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      (json['elevation'] as num).toDouble(),
      json['location_name'] as String,
      json['version'] as String,
      json['state'] as String,
      json['currency'] as String,
      json['config_source'] as String,
      json['config_dir'] as String,
      json['time_zone'] as String,
      json['safe_mode'] as bool,
      (json['whitelist_external_dirs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['allowlist_external_dirs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['allowlist_external_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['components'] as List<dynamic>).map((e) => e as String).toList(),
      Map<String, String>.from(json['unit_system'] as Map),
      json['external_url'] as String?,
      json['internal_url'] as String?,
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
