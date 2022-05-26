import 'package:homsai/datastore/DTOs/websocket/device/device.dto.dart';
import 'package:homsai/datastore/models/area/base.area.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base.device.g.dart';

@JsonSerializable()
class Device {
  String id;
  List<Entity> entitys;
  Area area;
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

  Device({
    required this.id,
    required this.entitys,
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

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);

  static Device fromDeviceDto(
      DeviceDto deviceDto, Area area, List<Entity> entitys) {
    return Device(
      id: deviceDto.id,
      entitys: entitys,
      area: area,
      configurationUrl: deviceDto.configurationUrl,
      configEntries: deviceDto.configEntries,
      connections: deviceDto.connections,
      disabledBy: deviceDto.disabledBy,
      entryType: deviceDto.entryType,
      identifiers: deviceDto.identifiers,
      manufacturer: deviceDto.manufacturer,
      model: deviceDto.model,
      nameByUser: deviceDto.nameByUser,
      name: deviceDto.name,
      swVersion: deviceDto.swVersion,
      hwVersion: deviceDto.hwVersion,
      viaDeviceId: deviceDto.viaDeviceId,
    );
  }
}
