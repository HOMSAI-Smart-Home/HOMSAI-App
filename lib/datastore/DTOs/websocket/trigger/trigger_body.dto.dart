import 'package:json_annotation/json_annotation.dart';

part 'trigger_body.dto.g.dart';

@JsonSerializable()
class TriggerBodyDto {
  String state;
  String entityId;
  String from;
  String to;

  TriggerBodyDto(this.state, this.entityId, this.from, this.to);

  factory TriggerBodyDto.fromJson(Map<String, dynamic> json) =>
      _$TriggerBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TriggerBodyDtoToJson(this);
}
