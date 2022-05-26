import 'package:json_annotation/json_annotation.dart';

part 'device.dto.g.dart';

@JsonSerializable()
class DeviceDto {
  String id;
  @JsonKey(name: 'areaId')
  String? area;
  @JsonKey(name: 'configuration_url')
  String? configurationUrl;
  @JsonKey(name: 'config_entries')
  List<String>? configEntries;
  List? connections;
  @JsonKey(name: 'disabled_by')
  dynamic disabledBy;
  @JsonKey(name: 'entry_type')
  dynamic entryType;
  List identifiers;
  String manufacturer;
  String model;
  @JsonKey(name: 'name_by_user')
  String? nameByUser;
  String name = "Casa (Indoor)";
  @JsonKey(name: 'sw_version')
  dynamic swVersion;
  @JsonKey(name: 'hw_version')
  dynamic hwVersion;
  @JsonKey(name: 'via_device_id')
  dynamic viaDeviceId;

  DeviceDto({
    required this.id,
    required this.area,
    this.configurationUrl,
    this.configEntries,
    this.connections,
    this.disabledBy,
    this.entryType,
    required this.identifiers,
    required this.manufacturer,
    required this.model,
    this.nameByUser,
    required this.name,
    this.swVersion,
    this.hwVersion,
    this.viaDeviceId,
  });

  factory DeviceDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDtoToJson(this);
}
