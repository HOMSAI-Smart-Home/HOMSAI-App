import 'package:floor/floor.dart';
import 'package:homsai/datastore/dao/base.dao.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';

@dao
abstract class PlantDao extends BaseDao<Plant> {
  @Query('SELECT * FROM Plant')
  Future<List<Plant>> findAllPlants();

  @Query('SELECT * FROM Plant WHERE id = :id')
  Future<Plant?> findPlantById(int id);
}
