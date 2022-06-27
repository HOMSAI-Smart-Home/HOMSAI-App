import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart' as test;

import '../../util/database/database.dart';
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
      'Check HomeAssistant Configuration is retrieved correctly with friendly name',
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
      'Check HomeAssistant Configuration is retrieved correctly without friendly name',
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
      'Check HomeAssistant Configuration is retrieved correctly with mix friendly name',
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
  });
}
