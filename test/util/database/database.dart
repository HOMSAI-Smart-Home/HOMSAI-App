import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/dao/configuration.dao.dart';
import 'package:homsai/datastore/dao/home_assistant.dao.dart';
import 'package:homsai/datastore/dao/plant.dao.dart';
import 'package:homsai/datastore/dao/user.dao.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/database/user.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './database.mocks.dart';
import '../util.test.dart';

@GenerateMocks(
    [HomsaiDatabase, HomeAssistantDao, UserDao, ConfigurationDao, PlantDao])
class MocksHomsaiDatabase {
  static final Map<String, Entity> _entityMap = <String, Entity>{};
  static final MockHomsaiDatabase mockHomsaiDatabase = MockHomsaiDatabase();

  static void setUp({
    String hassConfigJsonPath = "assets/test/configuration.json",
    String hassEntitiesJsonPath = "assets/test/entities.json",
    User? user,
    Plant? plant,
    String? productionSensor,
    String? consumptionSensor,
    double? photovoltaicNominalPower,
    DateTime? photovoltaicInstallationDate,
    String? batterySensor,
  }) {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<HomsaiDatabase>(() => mockHomsaiDatabase);
    mockDao();
    mockUser(
        user ?? User("886a7145-7acc-40c4-96e5-da2f5ca2d87f", "demo@email.www"));
    mockPlant(plant ??
        Plant(
          "http://192.168.1.168:8123",
          "https://192.168.1.168:8123",
          "Test Plant",
          43.826926432510916,
          10.50297260284424,
          2,
          id: 0,
          productionSensor: productionSensor,
          consumptionSensor: consumptionSensor,
          photovoltaicNominalPower: photovoltaicNominalPower,
          photovoltaicInstallationDate: photovoltaicInstallationDate,
          batterySensor: batterySensor,
        ));
    mockConfigurationFrom(hassConfigJsonPath);
    mockEntitiesFrom(hassEntitiesJsonPath);
    mockEntityFromEntities();
  }

  static void mockDao() {
    when(mockHomsaiDatabase.homeAssitantDao)
        .thenAnswer((_) => MocksHomeAssistantDao.setUp());

    when(mockHomsaiDatabase.userDao).thenAnswer((invocation) {
      return MocksUserDao.setUp();
    });
    when(mockHomsaiDatabase.plantDao).thenAnswer((invocation) {
      return MocksPlantDao.setUp();
    });
    when(mockHomsaiDatabase.configurationDao).thenAnswer((invocation) {
      return MocksConfigurationDao.setUp();
    });
  }

  static void mockUser(User user) {
    when(mockHomsaiDatabase.getUser()).thenAnswer((invocation) async {
      return user;
    });
  }

  static void mockPlant(Plant plant) {
    when(mockHomsaiDatabase.getPlant()).thenAnswer((invocation) async {
      return plant;
    });
  }

  static void mockPlantWithOnlyLocalUrl() {
    mockPlant(Plant("http://192.168.1.168:8123", null, "Test Plant",
        43.826926432510916, 10.50297260284424, 2,
        id: 0));
  }

  static void mockPlantWithOnlyRemoteUrl() {
    mockPlant(Plant(null, "https://192.168.1.168:8123", "Test Plant",
        43.826926432510916, 10.50297260284424, 2,
        id: 0));
  }

  static void mockConfigurationFrom(String path) {
    when(mockHomsaiDatabase.getConfiguration()).thenAnswer((invocation) async {
      final Map<String, dynamic> config = await readJson(path);
      return Configuration.fromJson(config);
    });
  }

  static void mockEntitiesFrom(String path) {
    readJson(path).then((entitiesJson) {
      final List<Entity> entities =
          (entitiesJson as List<dynamic>).getEntities();
      mockEntities(entities);
    });
  }

  static void mockEntities(List<Entity> entities) {
    _entityMap.clear();

    for (var entity in entities) {
      _entityMap.putIfAbsent(entity.entityId, () => entity);
    }

    when(mockHomsaiDatabase.getEntities()).thenAnswer((invocation) async {
      return entities;
    });
  }

  static void mockEmptyEntities() {
    return mockEntities([]);
  }

  static void mockEntityFromEntities() {
    when(mockHomsaiDatabase.getEntity(any)).thenAnswer((invocation) async {
      final entityId = invocation.positionalArguments[0];
      return _entityMap[entityId];
    });
  }

  static void mockEntityBy(String entityId) {
    when(mockHomsaiDatabase.getEntity(any)).thenAnswer((invocation) async {
      return _entityMap[entityId];
    });
  }
}

class MocksHomeAssistantDao {
  static final MockHomeAssistantDao mockHomeAssistantDao =
      MockHomeAssistantDao();

  static MockHomeAssistantDao setUp() {
    when(mockHomeAssistantDao.insertEntities(any, any))
        .thenAnswer((_) async => []);
    when(mockHomeAssistantDao.updateItem(any)).thenAnswer((_) async => 1);
    when(mockHomeAssistantDao.deleteItem(any))
        .thenAnswer((realInvocation) async => {});
    when(mockHomeAssistantDao.deleteItems(any))
        .thenAnswer((realInvocation) async => {});
    when(mockHomeAssistantDao.forceDeleteItem(any))
        .thenAnswer((realInvocation) async => {});
    return mockHomeAssistantDao;
  }
}

class MocksUserDao {
  static final MockUserDao mocksUserDao = MockUserDao();

  static MockUserDao setUp() {
    when(mocksUserDao.updateItem(any)).thenAnswer((_) async => 1);
    return mocksUserDao;
  }
}

class MocksPlantDao {
  static final MockPlantDao mockPlantDao = MockPlantDao();

  static MockPlantDao setUp() {
    when(mockPlantDao.updateItem(any)).thenAnswer((_) async => 1);
    return mockPlantDao;
  }
}

class MocksConfigurationDao {
  static final MockConfigurationDao mockConfigurationDao =
      MockConfigurationDao();

  static MockConfigurationDao setUp() {
    when(mockConfigurationDao.updateItem(any)).thenAnswer((_) async => 1);
    return mockConfigurationDao;
  }
}
