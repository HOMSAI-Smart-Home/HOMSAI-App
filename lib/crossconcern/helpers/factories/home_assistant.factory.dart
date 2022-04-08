import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';

class HomeAssistantEntityFactory {
  static final Map<String, Type> _categories = {
    'light': LightEntity,
  };

  static Entity parse(Type type, Map<String, dynamic> json) {
    switch (type) {
      case LightEntity:
        return LightEntity.fromJson(json);
      case TogglableEntity:
        return TogglableEntity.fromJson(json);
      default:
        return Entity.fromJson(json);
    }
  }

  static String getCategoryFromType(Type type) {
    return _categories.keys.firstWhere(
        (category) => _categories[category] == type,
        orElse: () => "");
  }

  static String getCategory(Entity entity) {
    return entity.entityId.split(".").first;
  }

  static Type getCategoryType(String category) {
    return _categories[category] ?? Entity;
  }

  static Type getEntityType(Entity entity) {
    return getCategoryType(getCategory(entity));
  }

  static T? get<T extends Entity>(Map<String, dynamic> json) {
    Entity entity = parseFromJson(json);
    if (entity is T) return entity;
    return null;
  }

  static Entity parseFromJson(Map<String, dynamic> json) {
    Type type = getEntityType(parse(Entity, json));
    return parse(type, json);
  }
}
