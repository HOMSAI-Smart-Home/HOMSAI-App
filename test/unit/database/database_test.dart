import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/main.dart';

import '../../util/mockups.test.dart';

void main() {
  group("Database", () {
    setUp(() async {
      await MocksHomsaiDatabase.setUp();
    });

    test('User id should be correct', () async {
      final database = getIt.get<HomsaiDatabase>();
      final user = await database.getUser();
      expect(user?.id, "886a7145-7acc-40c4-96e5-da2f5ca2d87f");
    });
    test('User id should be incorrect', () async {
      final database = getIt.get<HomsaiDatabase>();
      final user = await database.getUser();
      expect(user?.id, isNot(""));
    });

    test('Plant local url should be correct', () async {
      final database = getIt.get<HomsaiDatabase>();
      final plant = await database.getPlant();
      expect(plant?.localUrl, "http://192.168.1.168:8123");
    });

    test('Plant remote url should be incorrect', () async {
      final database = getIt.get<HomsaiDatabase>();
      final plant = await database.getPlant();
      expect(plant?.remoteUrl, isNot("http://192.168.1.168:8123"));
    });

    test('Configuration should be incorrect', () async {
      final database = getIt.get<HomsaiDatabase>();
      final config = await database.getConfiguration();
      expect(config?.timezone, "Europe/Rome");
    });

    test('Entities count should be 64', () async {
      final database = getIt.get<HomsaiDatabase>();
      final entities = await database.getEntities();
      expect(entities.length, 64);
    });

    test(
        'Entity(light.lampadina_smart_4) friendly name should be "Lampadina Smart 4"',
        () async {
      final database = getIt.get<HomsaiDatabase>();
      final entity = await database.getEntity("light.lampadina_smart_4");
      expect(entity?.name, "Lampadina Smart 4");
    });
  });
}
