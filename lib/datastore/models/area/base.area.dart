import 'package:json_annotation/json_annotation.dart';

part 'base.area.g.dart';

@JsonSerializable()
class Area {
  @JsonKey(name: 'area_id')
  String id;
  String name;
  dynamic picture;

  Area({
    required this.id,
    required this.name,
    this.picture
  });

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);
}
