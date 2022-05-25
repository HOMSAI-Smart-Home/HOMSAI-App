import 'package:json_annotation/json_annotation.dart';

part 'entitys_from_device_body.dto.g.dart';

@JsonSerializable()
class EntitysFromDeviceBodyDto {
  @JsonKey(name: "item_type")
  final String itemType = "device";
  @JsonKey(name: "item_id")
  Map<String, dynamic>? itemId;

  EntitysFromDeviceBodyDto(this.itemId);

  factory EntitysFromDeviceBodyDto.fromJson(Map<String, dynamic> json) =>
      _$EntitysFromDeviceBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EntitysFromDeviceBodyDtoToJson(this);
}
