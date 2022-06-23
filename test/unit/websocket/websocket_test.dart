import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
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
  });
}
