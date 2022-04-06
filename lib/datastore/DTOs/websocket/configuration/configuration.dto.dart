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

  ConfigurationDto(
      this.latitude,
      this.longitude,
      this.elevation,
      this.locationName,
      this.version,
      this.state,
      this.currency,
      this.source,
      this.dir,
      this.timezone,
      this.isSafeMode,
      this.whitelistExternalDirs,
      this.allowExternalDirs,
      this.allowExternalUrls,
      this.components,
      this.unitSystem,
      this.externalUrl,
      this.internalUrl);

  factory ConfigurationDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationDtoToJson(this);
}
