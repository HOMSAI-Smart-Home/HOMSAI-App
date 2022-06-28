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
    return hassEntity != null ? hassEntity.entity as T : null;
  }
  @Query(
      "SELECT * FROM Entity WHERE plant_id = :id AND entity_id LIKE :category || '.%'")
  Future<List<HomeAssistantEntity>> getEntitiesFromCategory(
      int id, String category);

  @Query("SELECT * FROM Entity WHERE plant_id = :id")
  Future<List<HomeAssistantEntity>> getAllEntities(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertEntitiesReplace(List<HomeAssistantEntity> items);

  Future<List<int>> insertEntities(int plantId, List<hass.Entity> entities) {
    return insertEntitiesReplace(entities
        .getEntities<hass.Entity>()
        .map((entity) => HomeAssistantEntity(plantId, entity.entityId, entity))
        .toList());
  }

  Future<void> refreshPlantEntities(
      int plantId, List<hass.Entity> entities) async {
    final oldEntities = await getAllEntities(plantId);
    final newEntities = entities
        .map((entity) => HomeAssistantEntity(plantId, entity.entityId, entity))
        .toList();

    await deleteItems(
        oldEntities.where((entity) => !newEntities.contains(entity)).toList());
    await insertEntitiesReplace(newEntities);
  }
}
