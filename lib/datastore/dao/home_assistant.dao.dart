import 'package:floor/floor.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/dao/base.dao.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart' as hass;

@dao
abstract class HomeAssistantDao extends BaseDao<HomeAssistantEntity> {
  @Query(
      'SELECT * FROM Entity WHERE plant_id = :plantId AND entity_id LIKE :entityId')
  Future<HomeAssistantEntity?> findEntityById(int plantId, String entityId);

  Future<T?> findEntity<T extends hass.Entity>(
      int plantId, String entityId) async {
    final hassEntity = await findEntityById(plantId, entityId);
    return hassEntity?.entity as T;
  }

  Future<List<int>> insertEntities(int plantId, List<hass.Entity> entities) {
    return insertItems(entities
        .getEntities<hass.Entity>()
        .map((entity) => HomeAssistantEntity(plantId, entity.entityId, entity))
        .toList());
  }
}
