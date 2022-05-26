import 'package:json_annotation/json_annotation.dart';

part 'entitys_from_device_body.dto.g.dart';

@JsonSerializable()
class DeviceRelatedBodyDto {
  @JsonKey(name: "item_type")
  final String itemType = "device";
  @JsonKey(name: "item_id")
  final String itemId;

  DeviceRelatedBodyDto(this.itemId);

  factory DeviceRelatedBodyDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceRelatedBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceRelatedBodyDtoToJson(this);
}
