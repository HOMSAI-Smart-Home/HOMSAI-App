import 'package:homsai/crossconcern/helpers/factories/home_assistant.factory.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';

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
    }).where((entity) => entity != null).map<T>((entity) => entity!).toList();
  }
}
