import 'package:homsai/business/flutter_web_auth/flutter_web_auth.interface.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/add_sensor/bloc/add_sensor.bloc.dart';
import 'package:test/test.dart' as test;

import '../../../util/database/database.dart';
import '../../../util/websocket/websocket.dart';

class MockFlutterWebAuth implements FlutterWebAuthInterface {
  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
  }) {
    return Future.value(
      Uri.parse(url).replace(queryParameters: {
        HomeAssistantApiProprties.authResponseType: '12345',
      }).toString(),
    );
  }
}

Future<void> main() async {
  //EntitiesFetched
  test.group(
    'retrieve and check auth token from external home assistant login',
    () {
      Future<void> checkSensor({
        required bool expectEmpty,
      }) async {
        final bloc = AddSensorBloc(
          WebSocketBloc(),
          null,
        );

        await Future.delayed(const Duration(seconds: 2));

        test.expect(
          bloc.state.batterySensors,
          expectEmpty ? test.isEmpty : test.isNotEmpty,
        );

        test.expect(
          bloc.state.productionSensors,
          expectEmpty ? test.isEmpty : test.isNotEmpty,
        );

        test.expect(
          bloc.state.consumptionSensors,
          expectEmpty ? test.isEmpty : test.isNotEmpty,
        );
      }

      test.setUp(() async {
        await MocksHassWebsocket.setUp();
        await MocksHassWebsocket.mockStateConnection();
        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
      });

      test.test(
        'empty Entitys',
        () async {
          await MocksHomsaiDatabase.setUp();
          await MocksHassWebsocket.mockAreaList('assets/test/empty.json');
          await MocksHassWebsocket.mockFetchStates('assets/test/empty.json');
          await MocksHassWebsocket.mockDeviceRelated('assets/test/empty.json');
          await MocksHassWebsocket.mockDeviceList('assets/test/empty.json');
          await checkSensor(expectEmpty: true);
        },
      );

      test.test(
        'not empty Entitys',
        () async {
          await MocksHomsaiDatabase.setUp();
          await checkSensor(expectEmpty: false);
        },
      );
    },
  );
}
