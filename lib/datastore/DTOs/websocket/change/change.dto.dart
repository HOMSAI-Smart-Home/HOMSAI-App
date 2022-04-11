import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/context/context.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change.dto.g.dart';

@JsonSerializable()
class ChangeDto {
  DataDto data;
  @JsonKey(name: 'event_type')
  String eventType;
  @JsonKey(name: 'time_fired')
  String timeFired;
  String origin;
  ContextEntity context;

  ChangeDto(
      this.data, this.eventType, this.timeFired, this.origin, this.context);

  factory ChangeDto.fromJson(Map<String, dynamic> json) =>
      _$ChangeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeDtoToJson(this);
}

@JsonSerializable()
class DataDto {
  @JsonKey(name: 'entity_id')
  String entityId;
  @JsonKey(name: 'new_state')
  Map<String, dynamic> newState;
  @JsonKey(name: 'old_state')
  Map<String, dynamic> oldState;

  DataDto(this.entityId, this.newState, this.oldState);

  factory DataDto.fromJson(Map<String, dynamic> json) =>
      _$DataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataDtoToJson(this);
}
