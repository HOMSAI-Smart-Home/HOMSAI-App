import 'package:floor/floor.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/dao/base.dao.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart'
    as home_assistant;

@dao
abstract class HomeAssistantDao extends BaseDao<HomeAssistantEntity> {
  Future<List<int>> insertEntities(
      int plantId, List<home_assistant.Entity> entities) {
    return insertItems(entities
        .getEntities<home_assistant.Entity>()
        .map((entity) => HomeAssistantEntity(plantId, entity.entityId, entity))
        .toList());
  }
}
