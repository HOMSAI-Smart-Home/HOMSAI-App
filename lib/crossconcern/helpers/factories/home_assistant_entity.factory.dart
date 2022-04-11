import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/binary/binary_sensor.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';

import 'home_assistant_sensor.factory.dart';

class HomeAssistantEntityFactory {
  static final Map<String, Type> _entityCategories = {
    'light': LightEntity,
    'sensor': SensorEntity,
    'binary_sensor': BinarySensorEntity,
  };

  static Entity _parse(Type type, Map<String, dynamic> json) {
    switch (type) {
      case LightEntity:
        return LightEntity.fromJson(json);
      case MesurableSensorEntity:
        return MesurableSensorEntity.fromJson(json);
      case BinarySensorEntity:
        return BinarySensorEntity.fromJson(json);
      case SensorEntity:
        return SensorEntity.fromJson(json);
      default:
        return Entity.fromJson(json);
    }
  }

  static String _getCategory(Entity entity) {
    return entity.entityId.split(".").first;
  }

  static Type _getCategoryType(String category) {
    return _entityCategories[category] ?? Entity;
  }

  static Type _getEntityType(Map<String, dynamic> json) {
    final category = _getCategory(_parse(Entity, json));
    if (category == 'sensor') {
      return HomeAssistantSensorFactory.getSensorType(json['attributes']);
    }
    return _getCategoryType(category);
  }

  static T? get<T extends Entity>(Map<String, dynamic> json) {
    Entity entity = parseFromJson(json);
    if (entity is T) return entity;
    return null;
  }

  static String getCategoryFromType(Type type) {
    return _entityCategories.keys.firstWhere(
        (category) => _entityCategories[category] == type,
        orElse: () => "");
  }

  static Entity parseFromJson(Map<String, dynamic> json) {
    return _parse(_getEntityType(json), json);
  }
}
