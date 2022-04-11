import 'package:homsai/datastore/models/entity/attributes/attributes.entity.dart';
import 'package:homsai/datastore/models/entity/context/context.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base.entity.g.dart';

@JsonSerializable()
class Entity {
  @JsonKey(name: 'entity_id')
  String entityId;
  @JsonKey(name: "state")
  String state;
  Attributes attributes;
  @JsonKey(name: 'last_changed')
  DateTime lastChanged;
  @JsonKey(name: 'last_updated')
  DateTime lastUpdated;
  ContextEntity context;

  Entity(
    this.entityId,
    this.state,
    this.attributes,
    this.lastChanged,
    this.lastUpdated,
    this.context,
  );

  String get id => context.id;
  String get name => attributes.friendlyName;

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);
}

mixin TogglableEntity on Entity {
  bool get isOn => state.toLowerCase() == ToggableEntityState.on;

  void turnOn() {
    state = ToggableEntityState.on;
  }

  void turnOff() {
    state = ToggableEntityState.off;
  }
}

class ToggableEntityState {
  static String get on => "on";
  static String get off => "off";
}

mixin NumerableEntity on Entity {
  @JsonKey(ignore: true)
  double? get value => double.tryParse(state);

  set value(double? value) {
    state = value != null ? value.toString() : "unknown";
  }
}
