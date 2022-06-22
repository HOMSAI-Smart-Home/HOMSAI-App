import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/add_plant/bloc/add_plant.bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as test;
import 'package:timezone/data/latest.dart' as tz;

import '../../util/database/database.dart';
import 'add_plant_page_test.mocks.dart';

const configurationJson = {
  'allowlist_external_dirs': [],
  'allowlist_external_urls': [],
  'components': [],
  'currency': '',
  'config_dir': '',
  'elevation': 19,
  'safe_mode': false,
  'latitude': 0.1234,
  'location_name': 'name',
  'longitude': 0.1234,
  'config_source': '',
  'state': '',
  'time_zone': 'America/Detroit',
  'unit_system': {},
  'version': '',
  'whitelist_external_dirs': []
};

@GenerateMocks([HomeAssistantWebSocketInterface])
Future<void> main() async {
  test.group(
      'AddPlantPage, '
      'Check HomeAssistant Configuration is retrieved correctly', () {
    blocTest<AddPlantBloc, AddPlantState>(
      'Check HomeAssistant Configuration is retrieved correctly',
      setUp: () async {
        MocksHomsaiDatabase.setUp();
        tz.initializeTimeZones();
        final mockWebSocketRepository = MockHomeAssistantWebSocketInterface();

        // It enables to reassign an implementation of an interface, for example in Unit tests
        getIt.allowReassignment = true;

        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
        getIt.registerLazySingleton<HomeAssistantWebSocketInterface>(
            () => mockWebSocketRepository);

        when(mockWebSocketRepository.connect(
                onConnected: argThat(test.isNotNull, named: 'onConnected')))
            .thenAnswer((invocation) async {
          if (invocation.namedArguments['onConnected'] != null) {
            await invocation.namedArguments['onConnected']();
          }
        });

        when(mockWebSocketRepository.fetchingConfig(any))
            .thenAnswer((invocation) {
          if (invocation.positionalArguments[0] != null) {
            (invocation.positionalArguments[0] as WebSocketSubscriberInterface)
                .onDone(configurationJson);
          }
        });

        when(mockWebSocketRepository.setErrorFunction(
          onGenericException:
              argThat(test.anything, named: 'onGenericException'),
          onTokenException: argThat(test.anything, named: 'onTokenException'),
          onUrlException: argThat(test.anything, named: 'onUrlException'),
        )).thenAnswer((invocation) => {});
      },
      build: () => AddPlantBloc(
        WebSocketBloc(),
        '',
        null,
        true,
      ),
      act: (bloc) => bloc.webSocketBloc.add(
        FetchConfig(
          onConfigurationFetched: (config) {
            bloc.add(ConfigurationFetched(Configuration.fromDto(config)));
          },
        ),
      ),
      expect: () => [
        test.isA<AddPlantState>(),
      ],
    );
  });
}
