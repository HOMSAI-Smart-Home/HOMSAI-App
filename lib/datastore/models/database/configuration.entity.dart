import 'package:floor/floor.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/models/database/base.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'configuration.entity.g.dart';

@Entity(tableName: 'Configuration')
@JsonSerializable()
class Configuration extends BaseEntity {
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

  Configuration(
      int? id,
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
      this.internalUrl)
      : super(id);

  String get unitSystemType => unitSystem["temperature"] == "°C" ? "EU" : "US";

  factory Configuration.fromDto(ConfigurationDto configuration) {
    return Configuration.fromJson(configuration.toJson());
  }

  factory Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);
}
