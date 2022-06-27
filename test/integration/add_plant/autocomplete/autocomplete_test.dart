import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/helpers/models/forms/add_plant/coordinate.model.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/add_plant/bloc/add_plant.bloc.dart';
import 'package:test/test.dart' as test;
import 'package:timezone/data/latest.dart' as tz;

import '../../../util/database/database.dart';
import '../../../util/util.test.dart';
import '../../../util/websocket/websocket.dart';

Future<void> main() async {
  test.group(
    'Add Plant ',
    () {
      test.setUp(() async {
        MocksHomsaiDatabase.setUp();
        MocksHassWebsocket.setUp();

        getIt.allowReassignment = true;
        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
        tz.initializeTimeZones();
      });
      test.test(
        'check if autocomplete is correct',
        () async {
          final bloc = AddPlantBloc(
            WebSocketBloc(),
            '',
            null,
            true,
          );

          final configurationJson =
              await readJson("assets/test/configuration.json");

          Configuration configuration =
              Configuration.fromJson(configurationJson);

          bloc.webSocketBloc.add(FetchConfig(
            onConfigurationFetched: (config) {
              bloc.add(
                ConfigurationFetched(
                  Configuration.fromDto(config),
                ),
              );
            },
          ));

          await test.expectLater(
              bloc.stream,
              test.emitsInOrder([
                test.isA<AddPlantState>(),
              ]));

          final coordinate = Coordinate.dirty(
            "${configuration.latitude.toStringAsFixed(5)};${configuration.longitude.toStringAsFixed(5)}",
          );

          test.expect(
            bloc.state.initialPlantName,
            test.isNotNull,
          );

          test.expect(
            bloc.state.plantName,
            test.isNotNull,
          );

          test.expect(
            bloc.state.coordinate,
            test.isNotNull,
          );

          test.expect(
            bloc.state.initialPlantName,
            configuration.locationName,
          );

          test.expect(
            bloc.state.plantName.value,
            configuration.locationName,
          );

          test.expect(
            bloc.state.coordinate,
            coordinate,
          );

          test.expect(
            bloc.state.configuration,
            test.isA<Configuration>(),
          );

          test.expect(
            bloc.state.plantName.value,
            bloc.state.initialPlantName,
          );
        },
      );
    },
  );
}
