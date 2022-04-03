import 'package:json_annotation/json_annotation.dart';

part 'base.entity.g.dart';

@JsonSerializable()
class Entity {
  @JsonKey(name: 'entity_id')
  String entityId;

  Entity(this.entityId);

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);
}

@JsonSerializable()
class TogglableEntity extends Entity {
  String state;

  TogglableEntity(String entityId, this.state) : super(entityId);

  bool get isOn => state == ToggableEntityState.on;

  void turnOn() {
    state = ToggableEntityState.on;
  }

  void turnOff() {
    state = ToggableEntityState.off;
  }

  factory TogglableEntity.fromJson(Map<String, dynamic> json) =>
      _$TogglableEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TogglableEntityToJson(this);
}

class ToggableEntityState {
  static String get on => "on";
  static String get off => "off";
}
