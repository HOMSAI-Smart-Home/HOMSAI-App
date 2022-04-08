import 'package:floor/floor.dart';
import 'package:homsai/datastore/dao/base.dao.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';

@dao
abstract class ConfigurationDao extends BaseDao<Configuration> {
  @Query('SELECT * FROM Configuration WHERE id = :id')
  Future<Configuration?> findPlantById(int id);
}
