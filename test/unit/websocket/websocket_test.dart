import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/models/area/base.area.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/main.dart';

import '../../util/websocket/websocket.dart';

void main() {
  group("Websocket", () {
    setUp(() async {
      await MocksHassWebsocket.setUp();
    });

    test('Configuration should be retrieved', () async {
      final websocket = getIt.get<HomeAssistantWebSocketInterface>();
      websocket.fetchingConfig(WebSocketSubscriber(
        (data) {
          final config = Configuration.fromDto(ConfigurationDto.fromJson(data));
          expect(config.timezone, isNot("America/Detroit"));
        },
      ));
    });

    test('Entities should be retrived', () async {
      final websocket = getIt.get<HomeAssistantWebSocketInterface>();
      websocket.fetchingStates(WebSocketSubscriber(
        (data) {
          final List<Entity> entities = (data as List<dynamic>).getEntities();
          expect(entities.length, 64);
        },
      ));
    });

    test('Areas should be retrived', () async {
      final websocket = getIt.get<HomeAssistantWebSocketInterface>();
      websocket.getAreaList(WebSocketSubscriber(
        (data) {
          final List<Area> areas = (data as List<dynamic>).getAreas();
          for (var area in areas) {
            {
              expect(area.id, isNotNull);
            }
          }
          expect(areas.length, 6);
        },
      ));
    });

    test('States should be retrived', () async {
      final websocket = getIt.get<HomeAssistantWebSocketInterface>();
      websocket.fetchingStates(WebSocketSubscriber(
        (data) {
          final List<Entity> entities = (data as List<dynamic>).getEntities();
          for (var entity in entities) {
            {
              expect(entity.entityId, isNotNull);
              expect(entity.state, isNotNull);
            }
          }
          expect(entities.length, 64);
        },
      ));
    });
  });
}
