import 'package:homsai/datastore/models/entity/context/context.entity.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/ui/widget/devices/light/bloc/light_device.bloc.dart';
import 'package:test/test.dart';

import '../../util/apppreferences/app_preferences.dart';
import '../../util/database/database.dart';
import '../../util/light/light.dart';
import '../../util/websocket/websocket.dart';

Future<void> main() async {
  group(
    'Light Device',
    () {
      setUp(() async {
        await MocksHassWebsocket.setUp();
        MocksHomsaiDatabase.setUp();
        MocksAppPreferences.setUp();
        MocksLightRepository.setUp();
      });

      test(
        'Check light on',
        () async {
          final light = LightEntity(
            "entityId",
            "off",
            LightAttributes("lampadina"),
            DateTime.now(),
            DateTime.now(),
            ContextEntity("lampadina", null, null),
          );

          final bloc = LightDeviceBloc(light);

          MocksLightRepository.mockLightOn(
            light,
            (light) => bloc.add(LightNewState(light)),
          );

          bloc.add(LightOn(light));

          await expectLater(
            bloc.stream,
            emitsInOrder([isA<LightDeviceState>(), isA<LightDeviceState>()]),
          );

          expect(bloc.state.light.state, "on");
        },
      );

      test(
        'Check light off',
        () async {
          final light = LightEntity(
            "entityId",
            "on",
            LightAttributes("lampadina"),
            DateTime.now(),
            DateTime.now(),
            ContextEntity("lampadina", null, null),
          );

          final bloc = LightDeviceBloc(light);

          MocksLightRepository.mockLightOff(
            light,
            (light) => bloc.add(LightNewState(light)),
          );

          bloc.add(LightOn(light));

          await expectLater(
            bloc.stream,
            emitsInOrder([isA<LightDeviceState>(), isA<LightDeviceState>()]),
          );

          expect(bloc.state.light.state, "off");
        },
      );
    },
  );
}
