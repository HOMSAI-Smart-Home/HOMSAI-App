import 'package:homsai/crossconcern/helpers/factories/home_assistant_entity.factory.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_sensor.factory.dart';
import 'package:homsai/datastore/DTOs/websocket/device/device.dto.dart';
import 'package:homsai/datastore/models/area/base.area.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';

extension ListEntity on List {
  List<T> getEntities<T extends Entity>() {
    return map((entity) {
      if (entity is Map<String, dynamic>) {
        return HomeAssistantEntityFactory.get<T>(entity);
      }
      if (entity is HomeAssistantEntity && entity.entity is T) {
        return entity.entity as T;
      }
      if (entity is T) return entity;
      return null;
    }).whereType<T>().toList();
  }

  List<DeviceDto> getDevicesDto() {
    return map((device) {
      return DeviceDto.fromJson(device);
    }).toList();
  }

  List<Area> getAreas() {
    return map((area) => Area.fromJson(area)).toList();
  }
}

extension ListSensorEntity on List<SensorEntity> {
  List<T> filterSensorByDeviceClass<T extends SensorEntity>(
      DeviceClass deviceClass) {
    return where((sensor) {
      return sensor is T && sensor.isDeviceClassOf(deviceClass);
    }).map((sensor) => sensor as T).toList();
  }
}
