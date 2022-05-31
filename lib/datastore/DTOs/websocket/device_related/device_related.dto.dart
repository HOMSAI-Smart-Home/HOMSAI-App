import 'package:json_annotation/json_annotation.dart';

part 'device_related.dto.g.dart';

@JsonSerializable()
class DeviceRelatedDto {
  List<String>? area;
  @JsonKey(name: "config_entry")
  List<String>? configEntry;
  List<String>? entity;

  DeviceRelatedDto({
    this.area,
    this.configEntry,
    this.entity,
  });

  factory DeviceRelatedDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceRelatedDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceRelatedDtoToJson(this);
}
