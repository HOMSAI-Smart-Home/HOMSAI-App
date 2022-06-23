import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/ui/pages/add_sensor/bloc/add_sensor.bloc.dart';

import '../../util/apppreferences/app_preferences.dart';
import '../../util/database/database.dart';
import '../../util/websocket/websocket.dart';

Future<void> main() async {
  group('Sensor Page', () {
    setUp(() async {
      MocksHomsaiDatabase.setUp();
      await MocksHassWebsocket.setUp();
      MocksAppPreferences.setUp();
    });

    test("Retrieve correct entities", () async {
      final bloc = AddSensorBloc(WebSocketBloc(), null);
      expect(bloc.state.batterySensors.isEmpty, isTrue);
      expect(bloc.state.productionSensors.isEmpty, isTrue);
      expect(bloc.state.consumptionSensors.isEmpty, isTrue);
      await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<AddSensorState>(),
            isA<AddSensorState>(),
          ]));
      expect(bloc.state.productionSensors.isNotEmpty, isTrue);
      expect(bloc.state.consumptionSensors.isNotEmpty, isTrue);
      expect(bloc.state.batterySensors.isNotEmpty, isTrue);
    });
  });
}
