import 'package:json_annotation/json_annotation.dart';

part 'attributes.entity.g.dart';

@JsonSerializable()
class Attributes {
  @JsonKey(name: 'friendly_name')
  String? friendlyName;

  Attributes(this.friendlyName);

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
