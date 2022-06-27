import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart' as test;

import '../../util/database/database.dart';
import '../../util/util.test.dart';
import '../../util/websocket/websocket.dart';
import 'websocket_integration_test.mocks.dart';

@GenerateMocks([AppPreferences])
Future<void> main() async {
  test.group(
      'Websocket'
      'Check if entities are retrived correctly', () {
    final mockAppPreferences = MockAppPreferences();

    test.setUp(() async {
      await MocksHassWebsocket.setUp();
      MocksHomsaiDatabase.setUp();
      getIt.registerLazySingleton<AppPreferencesInterface>(
          () => mockAppPreferences);
    });

    test.test(
      'Check entities are retrieved correctly with friendly name',
      () async {
        final bloc = WebSocketBloc();
        bloc.add(FetchEntities(
          onEntitiesFetched: (entities) {
            for (var element in entities) {
              test.expect(element.name, test.isNotNull);
            }
          },
        ));
      },
    );

    test.test(
      'Check entities are retrieved correctly without friendly name',
      () async {
        await MocksHassWebsocket.mockFetchStates(
            "assets/test/entities_no_friendly_name.json");

        final bloc = WebSocketBloc();
        bloc.add(FetchEntities(
          onEntitiesFetched: (entities) {
            for (var element in entities) {
              test.expect(element.name, element.id);
            }
          },
        ));
      },
    );

    test.test(
      'Check entities are retrieved correctly with mix friendly name',
      () async {
        await MocksHassWebsocket.mockFetchStates(
            "assets/test/entities_mix_friendly_name.json");
        final bloc = WebSocketBloc();
        bloc.add(FetchEntities(
          onEntitiesFetched: (entities) {
            for (var element in entities) {
              test.expect(element.name, test.isNotNull);
            }
          },
        ));
      },
    );

    test.test(
      'Check areas are retrieved correctly',
      () async {
        await MocksHassWebsocket.mockFetchStates(
            "assets/test/entities_no_area.json");

        final List<dynamic> entitiesJson =
            await readJson("assets/test/entities.json");
        List<Entity> entitiesWithAreas = [];
        entitiesJson
            .getEntities<Entity>()
            .forEach((entity) => entitiesWithAreas.add(entity));

        final bloc = WebSocketBloc();
        bloc.add(FetchEntities(
          onEntitiesFetched: (entities) {
            entities.asMap().forEach((key, value) {
              test.expect(value.entityId, test.isNotNull);
              if (value.area != null) {
                test.expect(value.area?.id, entitiesWithAreas[key].area?.id);
              }
            });
          },
        ));
      },
    );

    test.test(
      'Check states are retrieved correctly',
      () async {
        final List<dynamic> entitiesJson =
            await readJson("assets/test/entities.json");
        List<Entity> entitiesFromJson = [];
        entitiesJson
            .getEntities<Entity>()
            .forEach((entity) => entitiesFromJson.add(entity));

        final bloc = WebSocketBloc();
        bloc.add(FetchEntities(
          onEntitiesFetched: (entities) {
            entities.asMap().forEach((key, value) {
              test.expect(value.entityId, test.isNotNull);
              test.expect(value.state, entitiesFromJson[key].state);
            });
          },
        ));
      },
    );
  });
}
