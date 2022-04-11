// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:homsai/datastore/models/entity/attributes/attributes.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/context/context.entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../crossconcern/helpers/factories/home_assistant_sensor.factory.dart';

part 'sensor.entity.g.dart';

@JsonSerializable()
class SensorEntity extends Entity with EquatableMixin {
  @override
  covariant SensorAttributes attributes;

  SensorEntity(
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

  factory SensorEntity.fromJson(Map<String, dynamic> json) =>
      _$SensorEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SensorEntityToJson(this);

  bool isDeviceClassOf(DeviceClass deviceClass) {
    return HomeAssistantSensorFactory.isDeviceClassOf(deviceClass, this);
  }

  DeviceClass get deviceClass => attributes.deviceClass;

  SensorEntity copy() {
    return SensorEntity.fromJson(toJson());
  }

  @override
  List<Object?> get props => [entityId];
}

@JsonSerializable()
class SensorAttributes extends Attributes {
  @JsonKey(name: 'device_class', defaultValue: DeviceClass.unknown)
  DeviceClass deviceClass;
  String? icon;

  SensorAttributes(
    String friendlyName,
    this.deviceClass,
    this.icon,
  ) : super(friendlyName);

  factory SensorAttributes.fromJson(Map<String, dynamic> json) =>
      _$SensorAttributesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SensorAttributesToJson(this);
}
