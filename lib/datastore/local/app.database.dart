import 'dart:async';
import 'package:floor/floor.dart';
import 'package:homsai/crossconcern/helpers/converters/database/home_assistant.converter.dart';
import 'package:homsai/crossconcern/helpers/converters/database/list.converter.dart';
import 'package:homsai/crossconcern/helpers/converters/database/map.converter.dart';
import 'package:homsai/crossconcern/utilities/properties/database.properties.dart';
import 'package:homsai/datastore/dao/configuration.dao.dart';
import 'package:homsai/datastore/dao/home_assistant.dao.dart';
import 'package:homsai/datastore/dao/plant.dao.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app.database.g.dart';

@TypeConverters([ListConverter, MapConverter, HomeAssistantConverter])
@Database(
    version: DatabaseProperties.version,
    entities: [Plant, Configuration, HomeAssistantEntity])
abstract class AppDatabase extends FloorDatabase {
  PlantDao get plantDao;
  ConfigurationDao get configurationDao;
  HomeAssistantDao get homeAssitantDao;
}
