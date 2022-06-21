import 'package:json_annotation/json_annotation.dart';

part 'configuration.dto.g.dart';

@JsonSerializable()
class ConfigurationDto {
  double latitude;
  double longitude;
  double elevation;
  @JsonKey(name: "location_name")
  String locationName;
  String version;
  String state;
  String currency;
  @JsonKey(name: 'config_source')
  String source;
  @JsonKey(name: 'config_dir')
  String dir;
  @JsonKey(name: 'time_zone')
  String timezone;
  @JsonKey(name: 'safe_mode')
  bool isSafeMode;
  @JsonKey(name: 'external_url')
  String? externalUrl;
  @JsonKey(name: 'internal_url')
  String? internalUrl;

  @JsonKey(name: "whitelist_external_dirs")
  List<String> whitelistExternalDirs;
  @JsonKey(name: "allowlist_external_dirs")
  List<String> allowExternalDirs;
  @JsonKey(name: "allowlist_external_urls")
  List<String> allowExternalUrls;

  List<String> components;

  @JsonKey(name: "unit_system")
  Map<String, String> unitSystem;

  ConfigurationDto({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.locationName,
    required this.version,
    required this.state,
    required this.currency,
    required this.source,
    required this.dir,
    required this.timezone,
    required this.isSafeMode,
    required this.whitelistExternalDirs,
    required this.allowExternalDirs,
    required this.allowExternalUrls,
    required this.components,
    required this.unitSystem,
    this.externalUrl,
    this.internalUrl,
  });

  factory ConfigurationDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationDtoToJson(this);
}
