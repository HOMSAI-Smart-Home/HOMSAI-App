import 'package:floor/floor.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_entity.factory.dart';
import 'package:homsai/datastore/dao/base.dao.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart'
    as home_assistant;

@dao
abstract class PlantDao extends BaseDao<Plant> {
  @Query('SELECT * FROM Plant')
  Future<List<Plant>> findAllPlants();

  @Query('SELECT * FROM Plant WHERE id = :id')
  Future<Plant?> findPlantById(int id);

  @Query('SELECT * FROM Plant WHERE active = 1 LIMIT 1')
  Future<Plant?> getActivePlant();

  @transaction
  Future<void> setActive(int id) async {
    List<Plant> plants = await findAllPlants();
    final newPlants = plants
        .map((plant) =>
            (plant.id! == id) ? plant.copyWith(isActive: true) : plant)
        .toList();
    await updateItems(newPlants);
  }

  @Query(
      "SELECT * FROM Entity WHERE plant_id = :id AND entity_id LIKE :category || '.%'")
  Future<List<HomeAssistantEntity>> getEntitiesFromCategory(
      int id, String category);

  @Query("SELECT * FROM Entity WHERE plant_id = :id")
  Future<List<HomeAssistantEntity>> getAllEntities(int id);

  Future<List<T>> getEntities<T extends home_assistant.Entity>(int id) async {
    final category = HomeAssistantEntityFactory.getCategoryFromType(T);
    final entities = await getEntitiesFromCategory(id, category);
    return entities.getEntities<T>();
  }
}
