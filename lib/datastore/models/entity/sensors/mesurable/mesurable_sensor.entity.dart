// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_sensor.factory.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/context/context.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mesurable_sensor.entity.g.dart';

@JsonSerializable()
class MesurableSensorEntity extends SensorEntity
    with NumerableEntity, EquatableMixin {
  @override
  covariant MesurableSensorAttributes attributes;

  MesurableSensorEntity(
    String entityId,
    String state,
    this.attributes,
    DateTime lastChanged,
    DateTime lastUpdated,
    ContextEntity context,
  ) : super(
          entityId,
          state,
          attributes,
          lastChanged,
          lastUpdated,
          context,
        );

  factory MesurableSensorEntity.fromJson(Map<String, dynamic> json) =>
      _$MesurableSensorEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MesurableSensorEntityToJson(this);

  String get unitMesurement => attributes.unit;

  @override
  MesurableSensorEntity copy() {
    return MesurableSensorEntity.fromJson(toJson());
  }

  @override
  List<Object?> get props => [entityId, state];
}

@JsonSerializable()
class MesurableSensorAttributes extends SensorAttributes {
  @JsonKey(name: 'unit_of_measurement')
  String unit;
  @JsonKey(name: 'state_class')
  String? stateClass;

  MesurableSensorAttributes(
    String friendlyName,
    String? icon,
    DeviceClass deviceClass,
    this.unit,
    this.stateClass,
  ) : super(friendlyName, deviceClass, icon);

  factory MesurableSensorAttributes.fromJson(Map<String, dynamic> json) =>
      _$MesurableSensorAttributesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MesurableSensorAttributesToJson(this);
}
