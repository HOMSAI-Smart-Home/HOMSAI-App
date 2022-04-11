// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PlantDao? _plantDaoInstance;

  ConfigurationDao? _configurationDaoInstance;

  HomeAssistantDao? _homeAssitantDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Plant` (`url` TEXT NOT NULL, `remote` INTEGER NOT NULL, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `active` INTEGER NOT NULL, `configuration_id` INTEGER NOT NULL, `production_sensor_id` TEXT, `consumption_sensor_id` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, FOREIGN KEY (`configuration_id`) REFERENCES `Configuration` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Configuration` (`latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `elevation` REAL NOT NULL, `locationName` TEXT NOT NULL, `version` TEXT NOT NULL, `state` TEXT NOT NULL, `currency` TEXT NOT NULL, `source` TEXT NOT NULL, `dir` TEXT NOT NULL, `timezone` TEXT NOT NULL, `isSafeMode` INTEGER NOT NULL, `externalUrl` TEXT, `internalUrl` TEXT, `whitelistExternalDirs` TEXT NOT NULL, `allowExternalDirs` TEXT NOT NULL, `allowExternalUrls` TEXT NOT NULL, `components` TEXT NOT NULL, `unitSystem` TEXT NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Entity` (`entity_id` TEXT NOT NULL, `plant_id` INTEGER NOT NULL, `entity` TEXT NOT NULL, FOREIGN KEY (`plant_id`) REFERENCES `Plant` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`entity_id`, `plant_id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PlantDao get plantDao {
    return _plantDaoInstance ??= _$PlantDao(database, changeListener);
  }

  @override
  ConfigurationDao get configurationDao {
    return _configurationDaoInstance ??=
        _$ConfigurationDao(database, changeListener);
  }

  @override
  HomeAssistantDao get homeAssitantDao {
    return _homeAssitantDaoInstance ??=
        _$HomeAssistantDao(database, changeListener);
  }
}

class _$PlantDao extends PlantDao {
  _$PlantDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _plantInsertionAdapter = InsertionAdapter(
            database,
            'Plant',
            (Plant item) => <String, Object?>{
                  'url': item.url,
                  'remote': item.isUrlRemote ? 1 : 0,
                  'name': item.name,
                  'email': item.email,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'active': item.isActive ? 1 : 0,
                  'configuration_id': item.configurationId,
                  'production_sensor_id': item.productionSensor,
                  'consumption_sensor_id': item.consumptionSensor,
                  'id': item.id
                }),
        _plantUpdateAdapter = UpdateAdapter(
            database,
            'Plant',
            ['id'],
            (Plant item) => <String, Object?>{
                  'url': item.url,
                  'remote': item.isUrlRemote ? 1 : 0,
                  'name': item.name,
                  'email': item.email,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'active': item.isActive ? 1 : 0,
                  'configuration_id': item.configurationId,
                  'production_sensor_id': item.productionSensor,
                  'consumption_sensor_id': item.consumptionSensor,
                  'id': item.id
                }),
        _plantDeletionAdapter = DeletionAdapter(
            database,
            'Plant',
            ['id'],
            (Plant item) => <String, Object?>{
                  'url': item.url,
                  'remote': item.isUrlRemote ? 1 : 0,
                  'name': item.name,
                  'email': item.email,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'active': item.isActive ? 1 : 0,
                  'configuration_id': item.configurationId,
                  'production_sensor_id': item.productionSensor,
                  'consumption_sensor_id': item.consumptionSensor,
                  'id': item.id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Plant> _plantInsertionAdapter;

  final UpdateAdapter<Plant> _plantUpdateAdapter;

  final DeletionAdapter<Plant> _plantDeletionAdapter;

  @override
  Future<List<Plant>> findAllPlants() async {
    return _queryAdapter.queryList('SELECT * FROM Plant',
        mapper: (Map<String, Object?> row) => Plant(
            row['url'] as String,
            row['name'] as String,
            row['email'] as String,
            row['latitude'] as double,
            row['longitude'] as double,
            row['configuration_id'] as int,
            id: row['id'] as int?,
            isUrlRemote: (row['remote'] as int) != 0,
            productionSensor: row['production_sensor_id'] as String?,
            consumptionSensor: row['consumption_sensor_id'] as String?,
            isActive: (row['active'] as int) != 0));
  }

  @override
  Future<Plant?> findPlantById(int id) async {
    return _queryAdapter.query('SELECT * FROM Plant WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Plant(
            row['url'] as String,
            row['name'] as String,
            row['email'] as String,
            row['latitude'] as double,
            row['longitude'] as double,
            row['configuration_id'] as int,
            id: row['id'] as int?,
            isUrlRemote: (row['remote'] as int) != 0,
            productionSensor: row['production_sensor_id'] as String?,
            consumptionSensor: row['consumption_sensor_id'] as String?,
            isActive: (row['active'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<Plant?> getActivePlant() async {
    return _queryAdapter.query('SELECT * FROM Plant WHERE active = 1 LIMIT 1',
        mapper: (Map<String, Object?> row) => Plant(
            row['url'] as String,
            row['name'] as String,
            row['email'] as String,
            row['latitude'] as double,
            row['longitude'] as double,
            row['configuration_id'] as int,
            id: row['id'] as int?,
            isUrlRemote: (row['remote'] as int) != 0,
            productionSensor: row['production_sensor_id'] as String?,
            consumptionSensor: row['consumption_sensor_id'] as String?,
            isActive: (row['active'] as int) != 0));
  }

  @override
  Future<List<HomeAssistantEntity>> getEntitiesFromCategory(
      int id, String category) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Entity WHERE plant_id = ?1 AND entity_id LIKE ?2 || \'.%\'',
        mapper: (Map<String, Object?> row) => HomeAssistantEntity(row['plant_id'] as int, row['entity_id'] as String, _homeAssistantConverter.decode(row['entity'] as String)),
        arguments: [id, category]);
  }

  @override
  Future<List<HomeAssistantEntity>> getAllEntities(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Entity WHERE plant_id = ?1',
        mapper: (Map<String, Object?> row) => HomeAssistantEntity(
            row['plant_id'] as int,
            row['entity_id'] as String,
            _homeAssistantConverter.decode(row['entity'] as String)),
        arguments: [id]);
  }

  @override
  Future<int> insertItem(Plant item) {
    return _plantInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertItems(List<Plant> items) {
    return _plantInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Plant item) async {
    await _plantUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<Plant> item) async {
    await _plantUpdateAdapter.updateList(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Plant item) async {
    await _plantDeletionAdapter.delete(item);
  }

  @override
  Future<void> setActive(int id) async {
    if (database is sqflite.Transaction) {
      await super.setActive(id);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.plantDao.setActive(id);
      });
    }
  }
}

class _$ConfigurationDao extends ConfigurationDao {
  _$ConfigurationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _configurationInsertionAdapter = InsertionAdapter(
            database,
            'Configuration',
            (Configuration item) => <String, Object?>{
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'elevation': item.elevation,
                  'locationName': item.locationName,
                  'version': item.version,
                  'state': item.state,
                  'currency': item.currency,
                  'source': item.source,
                  'dir': item.dir,
                  'timezone': item.timezone,
                  'isSafeMode': item.isSafeMode ? 1 : 0,
                  'externalUrl': item.externalUrl,
                  'internalUrl': item.internalUrl,
                  'whitelistExternalDirs':
                      _listConverter.encode(item.whitelistExternalDirs),
                  'allowExternalDirs':
                      _listConverter.encode(item.allowExternalDirs),
                  'allowExternalUrls':
                      _listConverter.encode(item.allowExternalUrls),
                  'components': _listConverter.encode(item.components),
                  'unitSystem': _mapConverter.encode(item.unitSystem),
                  'id': item.id
                }),
        _configurationUpdateAdapter = UpdateAdapter(
            database,
            'Configuration',
            ['id'],
            (Configuration item) => <String, Object?>{
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'elevation': item.elevation,
                  'locationName': item.locationName,
                  'version': item.version,
                  'state': item.state,
                  'currency': item.currency,
                  'source': item.source,
                  'dir': item.dir,
                  'timezone': item.timezone,
                  'isSafeMode': item.isSafeMode ? 1 : 0,
                  'externalUrl': item.externalUrl,
                  'internalUrl': item.internalUrl,
                  'whitelistExternalDirs':
                      _listConverter.encode(item.whitelistExternalDirs),
                  'allowExternalDirs':
                      _listConverter.encode(item.allowExternalDirs),
                  'allowExternalUrls':
                      _listConverter.encode(item.allowExternalUrls),
                  'components': _listConverter.encode(item.components),
                  'unitSystem': _mapConverter.encode(item.unitSystem),
                  'id': item.id
                }),
        _configurationDeletionAdapter = DeletionAdapter(
            database,
            'Configuration',
            ['id'],
            (Configuration item) => <String, Object?>{
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'elevation': item.elevation,
                  'locationName': item.locationName,
                  'version': item.version,
                  'state': item.state,
                  'currency': item.currency,
                  'source': item.source,
                  'dir': item.dir,
                  'timezone': item.timezone,
                  'isSafeMode': item.isSafeMode ? 1 : 0,
                  'externalUrl': item.externalUrl,
                  'internalUrl': item.internalUrl,
                  'whitelistExternalDirs':
                      _listConverter.encode(item.whitelistExternalDirs),
                  'allowExternalDirs':
                      _listConverter.encode(item.allowExternalDirs),
                  'allowExternalUrls':
                      _listConverter.encode(item.allowExternalUrls),
                  'components': _listConverter.encode(item.components),
                  'unitSystem': _mapConverter.encode(item.unitSystem),
                  'id': item.id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Configuration> _configurationInsertionAdapter;

  final UpdateAdapter<Configuration> _configurationUpdateAdapter;

  final DeletionAdapter<Configuration> _configurationDeletionAdapter;

  @override
  Future<Configuration?> findPlantById(int id) async {
    return _queryAdapter.query('SELECT * FROM Configuration WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Configuration(
            row['id'] as int?,
            row['latitude'] as double,
            row['longitude'] as double,
            row['elevation'] as double,
            row['locationName'] as String,
            row['version'] as String,
            row['state'] as String,
            row['currency'] as String,
            row['source'] as String,
            row['dir'] as String,
            row['timezone'] as String,
            (row['isSafeMode'] as int) != 0,
            _listConverter.decode(row['whitelistExternalDirs'] as String),
            _listConverter.decode(row['allowExternalDirs'] as String),
            _listConverter.decode(row['allowExternalUrls'] as String),
            _listConverter.decode(row['components'] as String),
            _mapConverter.decode(row['unitSystem'] as String),
            row['externalUrl'] as String?,
            row['internalUrl'] as String?),
        arguments: [id]);
  }

  @override
  Future<int> insertItem(Configuration item) {
    return _configurationInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertItems(List<Configuration> items) {
    return _configurationInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Configuration item) async {
    await _configurationUpdateAdapter.update(item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<Configuration> item) async {
    await _configurationUpdateAdapter.updateList(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Configuration item) async {
    await _configurationDeletionAdapter.delete(item);
  }
}

class _$HomeAssistantDao extends HomeAssistantDao {
  _$HomeAssistantDao(this.database, this.changeListener)
      : _homeAssistantEntityInsertionAdapter = InsertionAdapter(
            database,
            'Entity',
            (HomeAssistantEntity item) => <String, Object?>{
                  'entity_id': item.entityId,
                  'plant_id': item.plantId,
                  'entity': _homeAssistantConverter.encode(item.entity)
                }),
        _homeAssistantEntityUpdateAdapter = UpdateAdapter(
            database,
            'Entity',
            ['entity_id', 'plant_id'],
            (HomeAssistantEntity item) => <String, Object?>{
                  'entity_id': item.entityId,
                  'plant_id': item.plantId,
                  'entity': _homeAssistantConverter.encode(item.entity)
                }),
        _homeAssistantEntityDeletionAdapter = DeletionAdapter(
            database,
            'Entity',
            ['entity_id', 'plant_id'],
            (HomeAssistantEntity item) => <String, Object?>{
                  'entity_id': item.entityId,
                  'plant_id': item.plantId,
                  'entity': _homeAssistantConverter.encode(item.entity)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final InsertionAdapter<HomeAssistantEntity>
      _homeAssistantEntityInsertionAdapter;

  final UpdateAdapter<HomeAssistantEntity> _homeAssistantEntityUpdateAdapter;

  final DeletionAdapter<HomeAssistantEntity>
      _homeAssistantEntityDeletionAdapter;

  @override
  Future<int> insertItem(HomeAssistantEntity item) {
    return _homeAssistantEntityInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertItems(List<HomeAssistantEntity> items) {
    return _homeAssistantEntityInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(HomeAssistantEntity item) async {
    await _homeAssistantEntityUpdateAdapter.update(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItems(List<HomeAssistantEntity> item) async {
    await _homeAssistantEntityUpdateAdapter.updateList(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(HomeAssistantEntity item) async {
    await _homeAssistantEntityDeletionAdapter.delete(item);
  }
}

// ignore_for_file: unused_element
final _listConverter = ListConverter();
final _mapConverter = MapConverter();
final _homeAssistantConverter = HomeAssistantConverter();