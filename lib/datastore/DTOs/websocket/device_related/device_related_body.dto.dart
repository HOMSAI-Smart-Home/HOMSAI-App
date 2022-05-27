import 'package:json_annotation/json_annotation.dart';

part 'device_related_body.dto.g.dart';

@JsonSerializable()
class DeviceRelatedBodyDto {
  @JsonKey(name: "item_type")
  final String itemType;
  @JsonKey(name: "item_id")
  final String itemId;

  DeviceRelatedBodyDto(
    this.itemId, {
    this.itemType = "device",
  });

  factory DeviceRelatedBodyDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceRelatedBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceRelatedBodyDtoToJson(this);
}
