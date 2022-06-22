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

import 'mockups.test.mocks.dart';
import 'util.test.dart';

@GenerateMocks([HomsaiDatabase])
class MocksHomsaiDatabase {
  static final Map<String, Entity> entityMap = <String, Entity>{};

  static Future<void> setUp({
    String hassConfigJsonPath = "assets/test/configuration.json",
    String hassEntitiesJsonPath = "assets/test/entities.json",
    User? user,
    Plant? plant,
    String? productionSensor,
    String? consumptionSensor,
    double? photovoltaicNominalPower,
    DateTime? photovoltaicInstallationDate,
    String? batterySensor,
  }) async {
    final MockHomsaiDatabase mockHomsaiDatabase = MockHomsaiDatabase();

    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<HomsaiDatabase>(() => mockHomsaiDatabase);

    when(mockHomsaiDatabase.getUser()).thenAnswer((invocation) async {
      return user ??
          User("886a7145-7acc-40c4-96e5-da2f5ca2d87f", "demo@email.www");
    });
    when(mockHomsaiDatabase.getPlant()).thenAnswer((invocation) async {
      return plant ??
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
          );
    });
    when(mockHomsaiDatabase.getConfiguration()).thenAnswer((invocation) async {
      final config = await readJson(hassConfigJsonPath);
      return Configuration.fromJson(config);
    });

    final List<dynamic> entitiesJson = await readJson(hassEntitiesJsonPath);
    final List<Entity> entities = entitiesJson.getEntities();

    for (var entity in entities) {
      entityMap.putIfAbsent(entity.entityId, () => entity);
    }

    when(mockHomsaiDatabase.getEntities()).thenAnswer((invocation) async {
      return entities;
    });

    when(mockHomsaiDatabase.getEntity(any)).thenAnswer((invocation) async {
      final entityId = invocation.positionalArguments[0];
      return entityMap[entityId];
    });
  }
}
