import 'dart:async';
import 'package:floor/floor.dart';
import 'package:homsai/crossconcern/helpers/converters/database/home_assistant.converter.dart';
import 'package:homsai/crossconcern/helpers/converters/database/list.converter.dart';
import 'package:homsai/crossconcern/helpers/converters/database/map.converter.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_entity.factory.dart';
import 'package:homsai/crossconcern/utilities/properties/database.properties.dart';
import 'package:homsai/datastore/dao/configuration.dao.dart';
import 'package:homsai/datastore/dao/home_assistant.dao.dart';
import 'package:homsai/datastore/dao/plant.dao.dart';
import 'package:homsai/datastore/dao/user.dao.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/database/user.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart' as hass;
import 'package:homsai/main.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app.database.g.dart';

@TypeConverters([ListConverter, MapConverter, HomeAssistantConverter])
@Database(
    version: DatabaseProperties.version,
    entities: [User, Plant, Configuration, HomeAssistantEntity])
abstract class AppDatabase extends FloorDatabase {
  final AppPreferencesInterface _appPreferences =
      getIt.get<AppPreferencesInterface>();

  UserDao get userDao;
  PlantDao get plantDao;
  ConfigurationDao get configurationDao;
  HomeAssistantDao get homeAssitantDao;

  Future<Configuration?> getConfiguration() async {
    final Plant? plant = await getPlant();
    if (plant == null) return null;
    return await configurationDao.findConfigurationById(plant.configurationId);
  }

  Future<List<T>> getEntities<T extends hass.Entity>() async {
    final Plant? plant = await getPlant();
    if (plant == null || plant.id == null) return [];

    final category = HomeAssistantEntityFactory.getCategoryFromType(T);
    final entities =
        await homeAssitantDao.getEntitiesFromCategory(plant.id!, category);
    return entities.getEntities<T>();
  }

  Future<void> updatePlant(int? plantId) async {
    final user = await getUser();
    if (user != null) {
      await userDao.updateItem(user.copyWith(plantId: plantId));
    }
  }

  Future<User?> getUser() async {
    final userId = _appPreferences.getUserId();
    if (userId != null) {
      return await userDao.findUserById(userId);
    }
    return null;
  }

  Future<Plant?> getPlant() async {
    final user = await getUser();
    if (user != null && user.isPlantAvailable) {
      return await plantDao.findPlantById(user.plantId!);
    }
    return null;
  }

  Future<T?> getEntity<T extends hass.Entity>(String entityId) async {
    final plant = await getPlant();
    if (plant == null) return null;

    final homeAssistantEntity = await homeAssitantDao.findEntityById(plant.id!, entityId);
    return homeAssistantEntity?.entity as T;
  }

  Future<void> logout() async {
    final user = await getUser();
    if (user == null) return;
    //user.plantId = null;
    //await userDao.updateItem(user);
    _appPreferences.logout();
  }
}
