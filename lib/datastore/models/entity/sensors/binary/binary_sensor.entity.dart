// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_sensor.factory.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/context/context.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'binary_sensor.entity.g.dart';

@JsonSerializable()
class BinarySensorEntity extends SensorEntity
    with TogglableEntity, EquatableMixin {
  @override
  covariant BinarySensorAttributes attributes;

  BinarySensorEntity(
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

  factory BinarySensorEntity.fromJson(Map<String, dynamic> json) =>
      _$BinarySensorEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BinarySensorEntityToJson(this);

  @override
  BinarySensorEntity copy() {
    return BinarySensorEntity.fromJson(toJson());
  }

  @override
  List<Object?> get props => [entityId];
}

@JsonSerializable()
class BinarySensorAttributes extends SensorAttributes {
  BinarySensorAttributes(
    String friendlyName,
    DeviceClass deviceClass,
    String? icon,
  ) : super(friendlyName, deviceClass, icon);

  factory BinarySensorAttributes.fromJson(Map<String, dynamic> json) =>
      _$BinarySensorAttributesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BinarySensorAttributesToJson(this);
}
