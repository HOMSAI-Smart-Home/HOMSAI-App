import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
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

@GenerateMocks([HomsaiDatabase])
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
    mockPlant(Plant(
      "http://192.168.1.168:8123",
      null,
      "Test Plant",
      43.826926432510916,
      10.50297260284424,
      2,
    ));
  }

  static void mockPlantWithOnlyRemoteUrl() {
    mockPlant(Plant(
      null,
      "https://192.168.1.168:8123",
      "Test Plant",
      43.826926432510916,
      10.50297260284424,
      2,
    ));
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
